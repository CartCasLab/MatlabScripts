# MatlabScripts
A recollection of useful matlab scripts

# Instructions

To operate this folder first clone the repository under your chosen path and name (otherwise it will be MatlabScripts):
```sh
cd <desired_path>
git clone https://github.com/CartCasLab/MatlabScripts.git <optional_name>
```

Next step is optional, but recommended. Open MATLAB and call `pathtool` in the GUI command window. Then, select the desired folders under your system to be added.
This step will add the repo scripts to your search path, therefore making them available at all time inside the MATLAB environment. (beware not to add .git folder by accident or forgetting important subfolders).

# Notes

The master branch is considered the stable repository.
Therefore, if you don't aim at adding features or mangling with possible bugs, you may want to clone only the master branch. 
In any case, you can specify which branch you want to clone:
```sh
git clone --single-branch --branch <branchname> https://github.com/CartCasLab/MatlabScripts.git
```
