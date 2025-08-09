# matlabPlotSDF

[![Unit_Tests](https://github.com/btmy87/matlabPlotSDF/actions/workflows/testing.yml/badge.svg)](https://github.com/btmy87/matlabPlotSDF/actions/workflows/testing.yml)

[<img src="https://www.mathworks.com/matlabcentral/images/matlab%2Dfile%2Dexchange.svg">](https://www.mathworks.com/matlabcentral/fileexchange/181749-plotsdf)

Plot 3D SD files in MATLAB.

SDF files contain computed 3D shapes for molecules.
Files can be obtained from webbook.nist.gov

Download example files using the appropriate script:
  - Windows: `get_example_files.bat`
  - Linux or Mac: `get_example_files.sh`
  - Within MATLAB: `get_example_files`, This will work in MATLAB Online

Then plot from within matlab.
  - `plotSDF("caffeine.sdf");` to plot a given file
  - `plotSDF();` to select file using dialog box

![image of caffeine molecule](caffeine.png)

