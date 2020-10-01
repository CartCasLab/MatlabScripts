function Result = ini2struct(FileName)
%==========================================================================
%  Author GBe
%==========================================================================
% 
% Serves as imgLabels reader to obtain info on raw projs
% =========================================================================
Result = [];                            % we have to return something
CurrMainField = '';                     % it will be used later
f = fopen(FileName,'r');                % open file
while ~feof(f)                          % and read until it ends
    s = strtrim(fgetl(f));              % Remove any leading/trailing spaces
    if isempty(s)
        continue;
    end;
    if (s(1)==';')                      % ';' start comment lines
        continue;
    end;
    if (s(1)=='#')                      % '#' start comment lines
        continue;
    end;
    if (s(1)=='%')                      % '%' start comment lines
        continue;  
    end;
%     if ( s(1)=='[' ) && (s(end)==']' )
%         % We found section
%         CurrMainField = genvarname(lower(s(2:end-1)));
%         Result.(CurrMainField) = [];    % Create field in Result
%     else
        % ??? This is not a section start
        [par,val] = strtok(s, ' ');
        val = CleanValue(val);
        [filepath,name,ext] = fileparts(par);
%         if ~isempty(CurrMainField)
%             % But we found section before and have to fill it
%             Result.(CurrMainField).(lower(genvarname(par))) = val;
%         else
            % No sections found before. Orphan value
%             Result.(lower(genvarname(par))) = val;
            Result.(genvarname(name)) = val;
%         end
    end
% end
fclose(f);
return;

function res = CleanValue(s)
res = strtrim(s);
if strcmpi(res(1),' ')
    res(1)=[];
end
res = strtrim(res);
return;
