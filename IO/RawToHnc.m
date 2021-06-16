% Read raw files
for k= 1:1%503;
fid = fopen(num2str(k,'image_%05d.raw'),'r');
tmp = fread(fid,'ushort');
% P(:,:,k) = permute(reshape(uint16(tmp),[1024,768]),[2,1,3]);
Prawwritten = reshape(uint16(tmp),[1024,768]);
fclose(fid);
end;

% Prepare Hnc header
load hncHeaderTemplate.mat
info = hncHeaderTemplate;
info.uiSizeX = 768; info.uiSizeY = 1024;

% Write to hnc files
for k = 1:613;
% The recorded angle value follows the inverted convention of normal Hnc convention
info.dCTProjectionAngle = -ang(k);
info.dCBCTPositiveAngle = mod(-ang(k)+270,360);
HncWrite(info,P(:,:,k)',num2str(k,'image_%05d.hnc'));
end;