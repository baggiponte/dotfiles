import Foundation

let targetItem = ProcessInfo.processInfo.environment["NAME"] ?? "audio.route"
let switchAudio = "/opt/homebrew/bin/SwitchAudioSource"
let pluginDir = (ProcessInfo.processInfo.environment["HOME"] ?? "") + "/.config/sketchybar/plugins"
let menuPrefix = "audio.route.menu.swift"

enum DeviceKind: String {
    case output
    case input
}

@discardableResult
func run(_ launchPath: String, _ args: [String]) -> (Int32, String) {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: launchPath)
    process.arguments = args

    let out = Pipe()
    process.standardOutput = out
    process.standardError = Pipe()

    do {
        try process.run()
        process.waitUntilExit()
        let data = out.fileHandleForReading.readDataToEndOfFile()
        let text = String(data: data, encoding: .utf8) ?? ""
        return (process.terminationStatus, text)
    } catch {
        return (1, "")
    }
}

func sketchybar(_ args: [String]) {
    _ = run("/opt/homebrew/bin/sketchybar", args)
}

func sbSet(_ args: [String]) {
    sketchybar(["--set"] + args)
}

func hasSwitchAudio() -> Bool {
    FileManager.default.isExecutableFile(atPath: switchAudio)
}

func listDevices(kind: DeviceKind) -> [String] {
    let (status, output) = run(switchAudio, ["-a", "-t", kind.rawValue])
    guard status == 0 else { return [] }
    return output
        .split(whereSeparator: \.isNewline)
        .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
        .filter { !$0.isEmpty }
}

func currentDevice(kind: DeviceKind) -> String {
    let (status, output) = run(switchAudio, ["-c", "-t", kind.rawValue])
    guard status == 0 else { return "" }
    return output.trimmingCharacters(in: .whitespacesAndNewlines)
}

func setDevice(kind: DeviceKind, device: String) {
    guard !device.isEmpty else { return }
    _ = run(switchAudio, ["-s", device, "-t", kind.rawValue])
}

func normalizeSpaces(_ value: String) -> String {
    value
        .split(whereSeparator: \.isWhitespace)
        .joined(separator: " ")
}

func compact(_ value: String) -> String {
    var text = value
        .replacingOccurrences(of: "(Bluetooth)", with: "")
        .replacingOccurrences(of: "(AirPlay)", with: "")
        .replacingOccurrences(of: "MacBook Pro Microphone", with: "Mac Mic")
        .replacingOccurrences(of: "MacBook Pro Speakers", with: "Mac Speakers")
        .replacingOccurrences(of: "MacBook Pro", with: "Mac")
    text = normalizeSpaces(text)
    if text.count > 24 {
        text = String(text.prefix(24)) + "…"
    }
    return text
}

func popupOpen() -> Bool {
    let (status, output) = run("/opt/homebrew/bin/sketchybar", ["--query", targetItem])
    guard status == 0, let data = output.data(using: .utf8) else { return false }
    guard
        let object = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
        let popup = object["popup"] as? [String: Any],
        let drawing = popup["drawing"] as? String
    else {
        return false
    }
    return drawing == "on"
}

func clearMenuItems() {
    sketchybar(["--remove", "/audio\\.route\\.menu\\.swift\\..*/"])
}

func b64(_ value: String) -> String {
    Data(value.utf8).base64EncodedString()
}

func addTitle(kind: DeviceKind) {
    let item = "\(menuPrefix).\(kind.rawValue).title"
    let label = kind == .output ? "Output" : "Input"
    sketchybar([
        "--add", "item", item, "popup.\(targetItem)",
        "--set", item,
        "icon.drawing=off",
        "label=\(label)",
        "label.align=left",
        "label.font=Hack Nerd Font:Bold:12.0",
        "label.color=0xffd8a657",
        "label.padding_left=10",
        "label.padding_right=10",
        "background.drawing=off",
        "click_script="
    ])
}

func addDeviceItem(kind: DeviceKind, idx: Int, device: String, current: String) {
    let item = "\(menuPrefix).\(kind.rawValue).\(idx)"
    let mark = device == current ? "􀆅" : ""
    let encoded = b64(device)
    let click = "\(pluginDir)/audio_route_swift.sh select \(kind.rawValue) \(encoded)"
    sketchybar([
        "--add", "item", item, "popup.\(targetItem)",
        "--set", item,
        "icon=\(mark)",
        "icon.color=0xffa9b665",
        "icon.padding_left=6",
        "icon.padding_right=4",
        "label=\(device)",
        "label.align=left",
        "label.max_chars=46",
        "label.padding_left=2",
        "label.padding_right=6",
        "background.corner_radius=6",
        "background.height=22",
        "click_script=\(click)"
    ])
}

func buildPopup() {
    clearMenuItems()

    let outCurrent = currentDevice(kind: .output)
    let inCurrent = currentDevice(kind: .input)
    let outs = listDevices(kind: .output)
    let ins = listDevices(kind: .input)

    addTitle(kind: .output)
    for (idx, device) in outs.enumerated() {
        addDeviceItem(kind: .output, idx: idx + 1, device: device, current: outCurrent)
    }

    addTitle(kind: .input)
    for (idx, device) in ins.enumerated() {
        addDeviceItem(kind: .input, idx: idx + 1, device: device, current: inCurrent)
    }
}

func setStatusLabel() {
    let out = currentDevice(kind: .output)
    if out.isEmpty {
        sbSet([targetItem, "label=Install SwitchAudioSource ▾", "icon.color=0xff928374"])
        return
    }
    let route = compact(out)
    sbSet([targetItem, "icon.color=0xff89b482", "label=Audio: \(route) ▾"])
}

let args = CommandLine.arguments
let action = args.count > 1 ? args[1] : "status"

if !hasSwitchAudio() {
    sbSet([targetItem, "label=Install SwitchAudioSource ▾", "icon.color=0xff928374"])
    exit(0)
}

switch action {
case "click":
    if popupOpen() {
        sbSet([targetItem, "popup.drawing=off"])
    } else {
        buildPopup()
        sbSet([targetItem, "popup.drawing=on"])
    }
case "select":
    let kindArg = args.count > 2 ? args[2] : "output"
    let deviceArg = args.count > 3 ? args[3] : ""
    if let kind = DeviceKind(rawValue: kindArg), !deviceArg.isEmpty {
        setDevice(kind: kind, device: deviceArg)
    }
    sbSet([targetItem, "popup.drawing=off"])
    setStatusLabel()
default:
    setStatusLabel()
}
