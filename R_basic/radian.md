

# radian 设置

```{json}
"r.rpath.linux": "/soft/sim/mambaforge/envs/Seurat/bin/R",
    "r.rterm.linux": "/soft/sim/mambaforge/envs/Seurat/bin/radian",
    "r.plot.useHttpgd": true,
    "r.rterm.option": [
        "--no-save",
        "--no-restore",
        "--interactive",
        "--r-binary=/soft/sim/mambaforge/envs/Seurat/bin/R"
    ],
```

.Rprofile

```{r}

options(radian.auto_match = FALSE)
options(radian.auto_indentation = FALSE)


···
