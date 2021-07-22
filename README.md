# SpheroidsImageProcessing

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.5121093.svg)](https://doi.org/10.5281/zenodo.5121093)

This repository contains codes used to batch-process confocal images of spheroids encoded with FUCCI.

## Requirements
1. MATLAB R2021a or later with the [image processing toolbox](https://www.mathworks.com/products/image.html)
2. [FIJI](https://imagej.net/software/fiji/downloads).

## Components
1. MATLAB app `AdjustRawImages.mlapp` used to manually adjust contrast raw tif images and embed necessary metadata.
2. Script `ProcessImages.m` used to perform the batch processing on a folder containing the output of component 1.
3. Folder `functions` containing necessary subroutines.
4. Folder `Demo` containing a demo script to demonstrate the algorothm. 
5. Folder `DemoImages` containing raw microscope images (oir), raw tif images and adjusted images, 
6. Document `SpheroidsImageProcessing.pdf` containing further details. Run `Demo/Demo.m` to reproduce Figure 1.

## Pipeline
1. Raw `oir` files are batch converted to `tif` using FIJI.
2. The FIJI macro `ExportInfoMacro.ijm` is run on the output folder from step 2 to produce a `txt` file for each image containing the metadata to be extracted by MATLAB.
3. The `AdjustRawImages.mlapp` is run (right click and select run) on the folder containing the raw `tif` and `txt` files. This will create two subfolders: `Adjusted` and `Original`. To demo, select `DemoImages/Original` in the prompt after running the app.
4. The `ProcessImages.m` script is run on the `Adjusted` folder from step 3. To demo, select `DemoImages/Adjusted` in the prompt after running the scipt.
5. After processing is complete, the images will display one-by-one along with an input prompt. 
  1. To keep the processed image, hit `y` then `Enter` (or just `Enter`). To reject, hit `n` then `Enter`. 
  2. Type a filename to save the data or press `n`. Press `Enter`. 
  3. Press `y` to filter the data (i.e., remove rejected images), else press `n`. Press `Enter`.
  4. Type a folder name to save the processed images or press `n`. Press `Enter`. 
6. The script will always save the processed data (including rejected images) to a `Processed-date-time.csv` file in the directory above the `Adjusted` folder selected.

## Authors
Alexander P Browning and Ryan J Murphy<br>
*School of Mathematical Sciences<br>Queensland University of Technology<br>Brisbane, Australia*
