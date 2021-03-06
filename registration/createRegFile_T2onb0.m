function createRegFile_CTonT1_MAZ01(registerFileName, fixedImage, movingImage, Tout, ImageOut, varargin)
%full paths can create problems when moving images around...create only child path
%IN:
% - registerFileName = path and name of the txt that plastimatch uses to
% register two images
% - fixedImage = fixed image in the registration (format = path/**_timepoint.format)
% - movingImage = moving image in the registration (format = path/**_timepoint.format)
% - Tout = output transform ('xf')
% - ImageOut = warped moving image (format = path/**_timepointONtimepoint.format)
% - varargin :
%     - 'tol' followed by tolerance for stopping the iterative process
%     - 'opt' followed by the optimizers accepted by plastimatch
%     - 'xform_in' followed by the filename of the initializing transformation as a txt file
%     - 'background' followed by the expected background value
%OUT: 
% command file for a rigid registration with plastimatch register

%% modify with parsing !!!!!!!!!!!
% to get the pure filename for any path, that uses either / or \
[regType_inv, regTimes_inv] = strtok( fliplr( ImageOut ), '\');
if isempty(regType_inv) || isempty(regTimes_inv)
    [regType_inv, regTimes_inv] = strtok( fliplr( ImageOut ), '/');
end
regType = fliplr(regType_inv);
pathOut = fliplr(regTimes_inv);
regTimes = fliplr( strtok( regTimes_inv, '\') );

[~, fixType_i] = strtok( fliplr(fixedImage), '_');
if ~isempty(fixType_i)
    fixType = fliplr(fixType_i);
else
    [fixType_i, ~] = strtok( fliplr(fixedImage(1:end-4)), '\'); %specifically for CT#.mha
    fixType = fliplr(fixType_i);
end
[~, movType_i] = strtok( fliplr(movingImage), '_');
if ~isempty(movType_i)
    movType = fliplr(movType_i);
else
    [movType_i, ~] = strtok( fliplr(movingImage), '\');
    movType = fliplr(movType_i);
end
%default values
toll = 0.000001;
optimi = 'versor'; %Stop optimization if change in score between it falls below this value
grad_tol = 'rsg_grad_tol';
filename_xf_in = [];
back_value=0.1;

%variable input
for i=1:2:length(varargin)
    switch varargin{i}
        case 'tol'
            toll = varargin{i+1}; %Stop optimization if change in score between it falls below this value
        case 'opt'
            optimi = varargin{i+1}; %improve robustness
            grad_tol = 'grad_tol';
        case 'xform_in'
            filename_xf_in = varargin{i+1};
        case 'background'
            back_value = varargin{i+1};
    end
end
%% actual file writing
fid = fopen( registerFileName, 'w' );
fprintf( fid, '[GLOBAL]\n' ); %%%r and n
fprintf( fid, 'fixed=%s\n', fixedImage );
fprintf( fid, 'moving=%s\n', movingImage );
fprintf( fid, 'xf_out=%s\n', Tout );
fprintf( fid, 'img_out=%s\n', ImageOut );
fprintf( fid, 'logfile=%s\n', [ pathOut 'regs_log\log_' regType '.txt' ] );

fprintf( fid, ['\n[STAGE]\n' 'xform=align_center\n\n'] );

fprintf( fid, ['\n[STAGE]\n' 'xform=rigid\n'] );
fprintf( fid, ['optim=' optimi '\n'] );
fprintf( fid, 'impl=itk\n' );
fprintf( fid, 'metric=mattes\n' );
fprintf( fid, 'max_its=1000\n' );
%fprintf( fid, 'convergence_tol=%.7f\n', toll);
fprintf( fid, [grad_tol '=0.000001\n'] ); %rsg only with versor
%fprintf( fid, 'res=4 4 1\n' );
%fprintf( fid, 'res_vox_fixed=1 1 1\n' );
fprintf( fid, 'res_vox_moving=4 4 2\n' );
%fprintf( fid, 'grid_spac=20 20 20\n' );
fprintf( fid, 'background_max=0\n' );
fprintf( fid, 'num_samples_pct=0.75\n' );
fprintf( fid, 'threading=openmp\n\n');
	

fprintf( fid, ['[STAGE]\n' 'xform=rigid\n'] );
fprintf( fid, ['optim=' optimi '\n'] );
fprintf( fid, 'impl=itk\n' );
fprintf( fid, 'metric=mattes\n' );
fprintf( fid, 'max_its=500\n' );
fprintf( fid, 'convergence_tol=%f\n', toll );
fprintf( fid, [grad_tol '=0.0001\n'] ); %rsg only with versor
fprintf( fid, 'res=2 2 1\n' );

fprintf( fid, ['\n[STAGE]\n' 'xform=affine\n'] );
fprintf( fid, ['optim=' optimi '\n'] );
fprintf( fid, 'impl=itk\n' );
fprintf( fid, 'metric=mattes\n' );
fprintf( fid, 'max_its=500\n' );
%fprintf( fid, 'convergence_tol=%.7f\n', toll);
fprintf( fid, [grad_tol '=0.0001\n'] ); %rsg only with versor
%fprintf( fid, 'res=2 2 1\n' );
%fprintf( fid, 'res_vox_fixed=1 1 1\n' );
fprintf( fid, 'res_vox_moving=2 2 1\n' );
%fprintf( fid, 'grid_spac=20 20 20\n' ); % for bspline
fprintf( fid, 'background_max=0\n\n' );
fprintf( fid, 'num_samples_pct=1\n' );
fprintf( fid, 'threading=openmp\n\n');


fclose(fid);