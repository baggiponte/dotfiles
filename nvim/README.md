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
  Time (mean ± σ):      18.3 ms ±   0.3 ms    [User: 10.9 ms, System: 5.0 ms]
  Range (min … max):    17.7 ms …  19.0 ms    142 runs

Benchmark 2: nvim +qa
  Time (mean ± σ):      31.3 ms ±   0.3 ms    [User: 21.5 ms, System: 7.3 ms]
  Range (min … max):    30.7 ms …  32.3 ms    89 runs

Summary
  'nvim -u NONE +qa' ran
    1.71 ± 0.03 times faster than 'nvim +qa'
```

### [`lazy.nvim`](https://github.com/folke/lazy.nvim) native profiler

```
Based on the actual CPU time of the Neovim process till UIEnter.
This is more accurate than `nvim --startuptime`.
  LazyStart 14.31ms
  LazyDone  28.72ms (+14.41ms)
  UIEnter   76.93ms (+48.21ms)
```
