# Performance

Using [`lazy.nvim`](https://github.com/folke/lazy.nvim)

## Benchmarks

### Using [`hyperfine`](https://github.com/sharkdp/hyperfine)

Command:

```bash
hyperfine "nvim -u NONE +qa" "nvim +qa" --warmup 5
```

Results:

```
Benchmark 1: nvim -u NONE +qa
  Time (mean ± σ):      15.6 ms ±   0.3 ms    [User: 8.6 ms, System: 5.3 ms]
  Range (min … max):    15.0 ms …  16.4 ms    165 runs

Benchmark 2: nvim +qa
  Time (mean ± σ):      33.0 ms ±   0.4 ms    [User: 21.7 ms, System: 9.4 ms]
  Range (min … max):    32.1 ms …  34.2 ms    85 runs

Summary
  nvim -u NONE +qa ran
    2.12 ± 0.04 times faster than nvim +qa
```

### [`lazy.nvim`](https://github.com/folke/lazy.nvim) native profiler

```
Startuptime: 125.27ms

Based on the actual CPU time of the Neovim process till UIEnter.
This is more accurate than `nvim --startuptime`.
  LazyStart 13.65ms
  LazyDone  34.83ms (+21.18ms)
  UIEnter   125.27ms (+90.45ms)
```
