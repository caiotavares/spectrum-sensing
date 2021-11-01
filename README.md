⚠️ _This repository is no longer being actively maintained_

# Spectrum Sensing with Machine Learning Models

This code was developed during my Master's Degree in Electrical Engineering.
It's not generalized nor fully self-explanatory yet, but might be useful for simulations of spectrum sensing.

For more information regarding the simulation results and setup, checkout my article [Machine learning-based models for spectrum sensing in cooperative radio networks](https://doi.org/10.1049/iet-com.2019.0941)

---
## Requirements

- [MATLAB](https://www.mathworks.com/products/matlab.html)
- [R Language](https://www.r-project.org/)

---
## Getting Started

```shell
$ git clone git@github.com:caiotavares/spectrum-sensing.git
```
Open MATLAB and set the current working dir to the one you previously downloaded the library with the **cd** command:

```matlab
cd 'C:\Users\MyUser\Desktop\spectrum-sensing'
```

All parameters of the simulation are set and configured in the `SS.m` file and be fine-tuned to accomplish the expected behaviour.
Run the `SS.m` file and you're good to go!

---
## Common Issues

```shell
'Rscript' is not recognized as an internal or external command, operable program or batch file
```

This error means you currently don't have the R language binary installed or set in your PATH variable. Follow the install instructions on the [R Project](https://cran.r-project.org/doc/FAQ/R-FAQ.html#How-can-R-be-installed_003f) according to your OS
