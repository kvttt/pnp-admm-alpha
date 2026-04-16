Plug-and-play ADMM with an alpha schedule
=========================================

The repository contains the code for reproducing all the results presented in the technical report "A plug-and-play method for model-based image reconstruction with guaranteed fixed-point convergence".


Follow the instructions [here](https://www.mathworks.com/matlabcentral/fileexchange/60641-plug-and-play-admm-for-image-restoration) to download Stanley Chan's PnP-ADMM code, and place the downloaded folder in the current directory. You should also make sure to download BM3D as specified in the instructions. The directory should look like this:

```
pnp-admm-alpha/
├── PlugPlay_v1/
│   ├── data/
│   ├── denoisers/
│       ├── BM3D/
│       └── RF/
│   ├── utilities/
│   └── *.m
├── PlugPlayADMM_super_alpha_log_output.m
├── PlugPlayADMM_super_log_output.m
├── README.md
├── script_superresolution_fig_*.m
└── script_superresolution_tab_*.m
```

The functions `PlugPlayADMM_super_alpha_log_output.m` and `PlugPlayADMM_super_log_output.m` are the main customized functions for running PnP-ADMM with the proposed alpha schedule and the original fixed rho schedule, respectively. Run the scripts `script_superresolution_*.m` to reproduce the results presented in the technical report. 

Figure 1.

![Figure 1](fig_1.png)

Figure 2.

![Figure 2](fig_2.png)

Figure 3.

![Figure 3](fig_3.png)

Figure 4.

![Figure 4a](fig_4_a.png)

![Figure 4b](fig_4_b.png)

Table 1.

| | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | Mean |
|--------|-----|-----|-----|-----|-----|-----|-----|-----|-----|------|------|------|------|-------|
| Fixed $\rho$ | 30.97 | 32.42 | 33.34 | 23.40 | 25.28 | 22.71 | 24.88 | 31.32 | 26.87 | 27.74 | 28.53 | 26.43 | 23.87 | 27.52 |
| Monotone $\rho$ | 32.99 | 36.05 | 37.06 | 23.70 | 25.69 | 23.22 | 25.25 | 33.11 | 27.15 | 29.10 | 29.32 | 26.81 | 24.03 | 28.73 |
| Proposed $\alpha$ | 31.07 | 32.89 | 33.65 | 23.52 | 25.46 | 22.88 | 25.02 | 31.54 | 27.05 | 27.96 | 28.75 | 26.63 | 23.98 | 27.72 |



