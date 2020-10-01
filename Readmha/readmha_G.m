function [A,Ainfo] = readmha_G(fn)
%% Usage: [A,Ainfo] = readmha_G(fn)

fp = fopen(fn,'rb');
if (fp == -1)
  error ('Cannot open mha file for reading');
end

%% Parse header
%dims = 3;
dims = 4;
binary = 1;
binary_msb = 0;
nchannels = 1;
Ainfo = [];
for i=1:20
  t = fgetl(fp);

  [a,cnt] = sscanf(t,'NDims = %d',1);
  if (cnt > 0)
    dims = a;
    continue;
  end

  [a,cnt] = sscanf(t,'BinaryData = %s',1);
  if (cnt > 0)
    if (strcmpi(a,'true'))
      binary = 1;
    else
      binary = 0;
    end
    continue;
  end

  [a,cnt] = sscanf(t,'BinaryDataByteOrderMSB = %s',1);
  if (cnt > 0)
    if (strcmpi(a,'true'))
      binary_msb = 1;
    else
      binary_msb = 0;
    end
    continue;
  end

  %% [a,cnt,errmsg,ni] = sscanf(t,'DimSize = ',1);
  ni = strfind(t,'DimSize = ');
  if (~isempty(ni))
    ni = ni + length('DimSize = ');
    [b,cnt] = sscanf(t(ni:end),'%d');
    if (cnt == dims)
      sz = b;
      continue;
    end
  end

  [a,cnt] = sscanf(t,'ElementNumberOfChannels = %d',1);
  if (cnt > 0)
    nchannels = a;
    continue;
  end

  [a,cnt] = sscanf(t,'ElementType = %s',1);
  if (cnt > 0)
    element_type = a;
    continue;
  end

  [a,cnt] = sscanf(t,'AnatomicalOrientation = %s',1);
  if (cnt > 0)
    Ainfo.AnatomicalOrientation = a;
    continue;
  end
  
  %% [a,cnt,errmsg,ni] = sscanf(t,'ElementSpacing = ',1);
  ni = strfind(t,'TransformMatrix = ');
  if (~isempty(ni))
    ni = ni + length('TransformMatrix = ');
    [b,cnt] = sscanf(t(ni:end),'%g');
    if (cnt == 9) %
      Ainfo.TransformMatrix = b;
      continue;
    end
  end
  %% [a,cnt,errmsg,ni] = sscanf(t,'ElementSpacing = ',1);
  ni = strfind(t,'ElementSpacing = ');
  if (~isempty(ni))
    ni = ni + length('ElementSpacing = ');
    [b,cnt] = sscanf(t(ni:end),'%g');
    if (cnt == dims)
      Ainfo.ElementSpacing = b;
      continue;
    end
  end
  
  %% [a,cnt,errmsg,ni] = sscanf(t,'Offset = ',1);
  ni = strfind(t,'Offset = ');
  if (~isempty(ni))
    ni = ni + length('Offset = ');
    [b,cnt] = sscanf(t(ni:end),'%g');
    if (cnt == dims)
      Ainfo.Offset = b;
      continue;
    end
  end
  
  [a,cnt] = sscanf(t,'ElementDataFile = %s',1);
  if (cnt > 0)
    data_loc = a;
    break;
  end
end

if(~strcmpi(data_loc,'LOCAL'))
    fclose(fp);
    fp = fopen(data_loc,'rb');
    if (fp == -1)
        error ('Cannot open data file for reading');
    end      
end

    if (strcmp(element_type,'MET_FLOAT'))
      [A,count] = fread(fp,sz(1)*sz(2)*sz(3)*nchannels,'float');
    elseif (strcmp(element_type,'MET_UCHAR'))
      [A,count] = fread(fp,sz(1)*sz(2)*sz(3)*nchannels,'uchar');
    elseif (strcmp(element_type,'MET_UINT'))
      [A,count] = fread(fp,sz(1)*sz(2)*sz(3)*nchannels,'uint32');
    else
      [A,count] = fread(fp,sz(1)*sz(2)*sz(3)*nchannels,'int16');
    end
%  A = reshape(A,sz(1),sz(2),sz(3),nchannels);
%  A = zlib_decompress(A,'short');

A = reshape(A,nchannels,sz(1),sz(2),sz(3)); %,sz(4));
A = shiftdim(A,1);

fclose(fp);

return;

% 
function M = zlib_decompress(Z,DataType)
import com.mathworks.mlwidgets.io.InterruptibleStreamCopier
a=java.io.ByteArrayInputStream(Z);
b=java.util.zip.InflaterInputStream(a);
isc = InterruptibleStreamCopier.getInterruptibleStreamCopier;
c = java.io.ByteArrayOutputStream;
isc.copyStream(b,c);
M=typecast(c.toByteArray,DataType);
