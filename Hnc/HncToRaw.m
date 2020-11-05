
clear all
close all
clc

%% Generate names

for k = 1:600 % change to your needs
    
    fnames{k} = num2str(k+1,'image_%d.hnc'); 
    
    
end


%% Read raw HNCs
uncropped_size = 1024 * 768;

for  k=1:length(fnames)
    fid = fopen(fnames{k},'r');
    tmp = fread(fid,'ushort');
    tmp_noheader = tmp(1+(length(tmp)-uncropped_size):end);
    P(:,:,k) = reshape(uint16(tmp_noheader),[768,1024]);
    fclose(fid);
end

%% Transpose back to raw convention

for ii = 1:size(P,3)
    P_raw(:,:,size(P,3)-ii+1) = P(:,:,ii)';
end

%% write raws

for k= 1:size(P_raw,3)
    fid = fopen(num2str(k-1,'image_%d.raw'),'w');
    P(P>2^16-1) = 2^16 -1;
    fwrite(fid,P(:),'uint16');    
    fclose(fid);
end

