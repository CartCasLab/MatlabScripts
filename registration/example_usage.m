clearvars
close all
clc
addpath(genpath(../../Matlab_scripts))
%% paths: 
% NB: use relative paths with plastimatch, to ha a clean and machine-independent register file
path_in = '/folder/with/all/files';
cd(path_in)
path_out = 'subfolder/to/main/folder'
path_to_xf = 'path/to/existing/xf'  % it must have the same format as plastimatch

fixedImage = fullfile(pre, 'T1_.mha']);
movingImage = fullfile(pre, 'CT_.mha']
Tout = fullfile(path_out, 'xf_CTonT1.txt');
imOut = fullfile(path_out, 'CTonT1.mha');
registerFileName = fullfile(regMRout, 'rigid_CTonT1.txt');
registerFileName_v2 = fullfile(regMRout, 'rigid_CTonT1_with_inputs.txt');

%% register file usage
createRegisterFile(registerFileName, fixedImage, movingImage, Tout, imOut);

%% use additional input parameters input x_form
createRegisterFile_T2onb0(registerFileName_v2, fixedImage, movingImage, Tout, imOut, ...
    'xform_in', fullfile(path_to_xf, 'xf_existing.txt'), ...
    'background', 40, 'tol', '0.001', 'opt', 'versor');

%% plastimatch registration
% OBS: plastimatch must be an environmental variable, otherwise write full path to executable
system(["plastimatch register " registerFileName])
system(["plastimatch register " registerFileName_v2])

