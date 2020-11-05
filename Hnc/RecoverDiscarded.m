function [renamed_cnt, fnames] = RecoverDiscarded()

% Utility function to recover projections "discarded" by gRTKReconstruction
% returns the number of renamed files and a cell array with the ones
% already correctly labeled (pro tip, run twice to get the whole stack)

fname=dir;
fname=fname(3:end);
cnt=1;
renamed_cnt = 0;

extension='.hnc';

for i=1:size(fname)    
    [punto, remain]=strtok(fname(i).name,'.');
    if strcmp(remain, extension)
        [punto1, remain1]=strtok(punto,'_');
        if strcmp(punto1, 'discarded')
            rename=strcat("image",remain1,extension);
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