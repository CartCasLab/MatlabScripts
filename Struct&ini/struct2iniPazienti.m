function struct2iniPazienti(filename,Structure)
%==========================================================================
% Author:      Dirk Lohse ( dirklohse@web.de )
% Version:     0.1a
% Last change: 2008-11-13
%==========================================================================
%
% struct2ini converts a given structure into an ini-file.
% It's the opposite to Andriy Nych's ini2struct. Only 
% creating an ini-file is implemented. To modify an existing
% file load it with ini2struct.m from:
%       Andriy Nych ( nych.andriy@gmail.com )
% change the structure and write it with struct2ini.
%

% Open file, or create new file, for writing
% discard existing contents, if any.
fid = fopen(filename,'w'); 

Sections = fieldnames(Structure);                     % returns the Sections

for i=1:length(Sections)
   Section = char(Sections(i));                       % convert to character
   
%    fprintf(fid,'[%s]',Section);                       % output [Section]
   
   member_value = Structure.(Section);               % returns members of Section
   if ~isempty(member_value)                         % check if member is empty
%       member_names = fieldnames(member_struct);
%       for j=1:length(member_names)
%          member_name = char(member_names(j));
%          member_value = Structure.(Section).(member_name);
         
         fprintf(fid,'%s %s\r\n',Section,member_value); % output member name and value
         
%       end % for-END (Members)
   end % if-END
end % for-END (Sections)
fprintf(fid,'%s',"#END OF FILE");
fclose(fid); % close file