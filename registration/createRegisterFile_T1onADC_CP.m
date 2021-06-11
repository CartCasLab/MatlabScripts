function createRegisterFile_T2onADC(registerFileName, fixedImage, movingImage, Tout, ImageOut, varargin)
%full paths can create problems when moving images around...create only child path
%IN:
% - registerFileName = path and name of the txt that plastimatch uses to
% register two images
% - fixedImage = fixed image in the registration
% - movingImage = moving image in the registration
% - Tout = output transform ('xf')
% - ImageOut = warped moving image
% - varargin = tolerance and optimization can be additionally defined
%OUT: 
% command file for a rigid registration with plastimatch register

% [regType, regTimes] = strtok( ImageOut, '_');
toll = 0.0000001; %this requires .7%f in convergence_tol
optimi = 'versor'; %Stop optimization if change in score between it falls below this value
grad_tol = 'rsg_grad_tol';

fid = fopen( registerFileName, 'w' );
fprintf( fid, '[GLOBAL]\n' ); %%%r and n
fprintf( fid, 'fixed=%s\n', fixedImage );
fprintf( fid, 'moving=%s\n', movingImage );
fprintf( fid, 'xf_out=%s\n', Tout );
fprintf( fid, 'img_out=%s\n', ImageOut );
%fprintf( fid, 'logfile=%s\n\n', [ regType '_log' regTimes(1:end-4) '.txt' ] );

fprintf( fid, ['\n[STAGE]\n' 'xform=translation\n'] );

fprintf( fid, ['\n[STAGE]\n' 'xform=rigid\n'] );
fprintf( fid, ['optim=' optimi '\n'] );
fprintf( fid, 'impl=itk\n' );
fprintf( fid, 'metric=mattes\n' );
fprintf( fid, 'max_its=400\n' );
fprintf( fid, 'convergence_tol=%.7f\n', toll );
%fprintf( fid, [grad_tol '=0.0001\n'] ); %rsg only with versor
fprintf( fid, 'res=4 4 1\n' );
fprintf( fid, 'grid_spac=40 40 40\n' );

fprintf( fid, ['\n[STAGE]\n' 'xform=rigid\n'] );
fprintf( fid, ['optim=' optimi '\n'] );
fprintf( fid, 'impl=itk\n' );
fprintf( fid, 'metric=mattes\n' );
fprintf( fid, 'max_its=500\n' );
fprintf( fid, 'convergence_tol=%.7f\n', toll);
fprintf( fid, [grad_tol '=0.000001\n'] ); %rsg only with versor
fprintf( fid, 'res=2 2 1\n' );
fprintf( fid, 'grid_spac=20 20 20\n' );

fclose(fid);