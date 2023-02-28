# Performance

Using [`lazy.nvim`](https://github.com/folke/lazy.nvim)

## Benchmarks

Baseline (no `init.lua` is loaded):

```bash
hyperfine "nvim -u NONE +qa" --warmup 5
```

```
Benchmark 1: nvim -u NONE +qa
  Time (mean ± σ):      18.2 ms ±   0.2 ms    [User: 11.1 ms, System: 4.8 ms]
  Range (min … max):    17.7 ms …  19.2 ms    145 runs
```

This setup:

```bash
hyperfine "nvim +qa" --warmup 5
```

```
Benchmark 1: nvim +qa
  Time (mean ± σ):      41.6 ms ±   0.4 ms    [User: 29.0 ms, System: 10.1 ms]
  Range (min … max):    41.0 ms …  43.2 ms    68 runs
```
