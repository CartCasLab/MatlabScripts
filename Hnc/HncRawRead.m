function [P, P_raw] = HncRawRead(fn, shape)
%% [P, P_raw]=HncRawRead(fn)
% ------------------------------------------
% FILE   : HncRead.m
% AUTHOR : Gabriele Belotti, CartCasLab, Politecnico di Milano
% DATE   : 2020-10-13  Created.
% ------------------------------------------
% PURPOSE
%   Read only the raw image content from a Varian HNC 2D file.
% ------------------------------------------
% INPUT
%   fn:     The path and filename of the input file.
%   shape:  Optional 1x2 vector for resolution/shape of image
% ------------------------------------------
%% Optional sizing

if nargin<2
    shape=[768,1024];
end

%% Reading raw content discarding header

uncropped_size = shape(1)*shape(2); % Expected projections' size
HEADEROFFSET = 256; % Header size to be ignored

fid = fopen(fn,'r');
tmp = fread(fid,'uint16');
% tmp_noheader = tmp(1+(length(tmp)-uncropped_size):end);
tmp_noheader = tmp(1+HEADEROFFSET:end);
P = reshape(uint16(tmp_noheader),shape);
fclose(fid);

%% Transpose back to raw convention

P_raw = P';


%% write raws - if ever needed
% 
% for k= 1:size(P_raw,3)
%     fid = fopen(num2str(k-1,'image_%d.raw'),'w');
%     P(P>2^16-1) = 2^16 -1;
%     fwrite(fid,P(:),'uint16');    
%     fclose(fid);
% end

