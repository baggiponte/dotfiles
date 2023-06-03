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
  Time (mean ± σ):      18.4 ms ±   0.3 ms    [User: 11.1 ms, System: 5.1 ms]
  Range (min … max):    17.8 ms …  19.6 ms    142 runs

Benchmark 2: nvim +qa
  Time (mean ± σ):      31.6 ms ±   0.4 ms    [User: 21.9 ms, System: 7.4 ms]
  Range (min … max):    30.9 ms …  32.6 ms    86 runs

Summary
  'nvim -u NONE +qa' ran
    1.72 ± 0.04 times faster than 'nvim +qa'
```

### [`lazy.nvim`](https://github.com/folke/lazy.nvim) native profiler

```
Startuptime: 82ms

Based on the actual CPU time of the Neovim process till UIEnter.
This is more accurate than `nvim --startuptime`.
  LazyStart 14.43ms
  LazyDone  29.69ms (+15.27ms)
  UIEnter   82ms (+52.31ms)
```
