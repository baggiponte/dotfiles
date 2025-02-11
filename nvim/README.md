# Performance

Using [`lazy.nvim`](https://github.com/folke/lazy.nvim)

## Compile from source

1. Install required dependencies:

```bash
brew install ninja cmake gettext curl
```

2. Clone the repository:

```bash
git clone https://github.com/neovim/neovim.git
```

3. Change directory to the repository:

```bash
cd neovim
```

4. Compile the source code:

```bash
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
```

[Reference]

## Benchmarks

### Using [`hyperfine`](https://github.com/sharkdp/hyperfine)

Command:

```bash
hyperfine "nvim -u NONE +qa" "nvim +qa" --warmup 5
```

Results:

```plaintext
Benchmark 1: nvim -u NONE +qa
  Time (mean ± σ):      17.3 ms ±   0.6 ms    [User: 9.7 ms, System: 5.7 ms]
  Range (min … max):    16.5 ms …  19.9 ms    146 runs

Benchmark 2: nvim +qa
  Time (mean ± σ):      31.8 ms ±   0.5 ms    [User: 20.8 ms, System: 9.1 ms]
  Range (min … max):    30.7 ms …  34.3 ms    88 runs

Summary
  nvim -u NONE +qa ran
    1.84 ± 0.07 times faster than nvim +qa
```
