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

The functions `PlugPlayADMM_super_alpha_log_output.m` and `PlugPlayADMM_super_log_output.m` are the main customized functions for running PnP-ADMM with the proposed alpha schedule and the original fixed rho schedule, respectively. Run the scripts `script_superresolution_*.m` to reproduce the results presented in the technical report. The results will be saved in the `results/` folder. Note that the scripts will automatically create the `results/` folder if it does not exist. The results include the reconstructed images, PSNR values, and log files containing the convergence information.
