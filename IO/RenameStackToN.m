function [renamed_cnt, fnames] = RenameStackToN(num)

% Utility function to add a numerical progression at filename in a stack of
% projections that you want to complement

fname=dir;
fname=fname(3:end);
cnt=1;
renamed_cnt = 0;

extension='.hnc';

for i=1:size(fname)    
    [punto, remain]=strtok(fname(i).name,'.');
    if strcmp(remain, extension)
        [punto1, remain1]=strtok(punto,'_');
        if strcmp(punto1, 'image')
            rename=strcat(num2str(num),"image",remain1,extension);
            movefile(fname(i).name, rename)
            renamed_cnt=renamed_cnt+1;
        else
            if strcmp(punto1, 'image')
                fnames{cnt}=fname(i).name;
            end
        end
        cnt = cnt+1;
    end
    if strcmp(remain, '.txt')
        imgLabelsFilename = fname(i).name;
    end    
end