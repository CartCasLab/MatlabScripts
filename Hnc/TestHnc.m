function [P, Patt, Pavg, Pavg_att] = TestHnc(P, ylimit)
% 
% This is a function to analyse a stack of projections. Contrary to what the 
% name suggests it may be used with any P-3D matrix provided it is passed as first argument,
% otherwise it will look for hnc in the current folder
% 
%% read image names only
if nargin < 1
    path=cd;
    D=dir;

    fname=dir;
    fname=fname(3:end);
    cnt=1;

    for i=1:size(fname)    
        [punto, remain]=strtok(fname(i).name,'.');
        if strcmp(remain, '.hnc')
            fnames{cnt}=fname(i).name;
            cnt = cnt+1;
        end
        if strcmp(remain, '.txt')
            imgLabelsFilename = fname(i).name;
        end    
    end

    imgLabels = imglabels2struct(imgLabelsFilename);
    ImageAngleNames = fieldnames(imgLabels);
    for ii = 1:length(ImageAngleNames)
        ang(ii) = str2double(strtok(imgLabels.(ImageAngleNames{ii}),' '));
    end

    %% Read raw HNCs
    uncropped_size = 1024 * 768;

    for  k=1:length(fnames)
        fid = fopen(fnames{k},'r');
        tmp = fread(fid,'ushort');
        tmp_noheader = tmp(1+(length(tmp)-uncropped_size):end);
        P(:,:,k) = reshape(uint16(tmp_noheader),[768,1024]);
    %     P(:,:,k) = reshape(uint16(tmp_noheader)',[1024,768]);
        fclose(fid);
    end
end
if nargin < 2
%         ylimit = [0 2^16-1];
         ylimit = [];
end

        
    %% Lin attenuation

    IDark = 0;
    I0 = 2^16-1;
    Patt_0 = P-IDark; 
    
%     Patt_0(Patt_0<1) = 1;
    Patt_0 = Patt_0+1;

    Patt_1 = log(double(Patt_0));

    Patt_2 = log(I0-IDark)*ones(size(Patt_1)); %I0 - IDark must of course be >=1

    Patt = Patt_2 - Patt_1;
    
    ylimit_att = ylimit + 1;
    ylimit_att = log(ylimit_att);

    %% Cropping
    Pcut_att=Patt(2:end-1,1:end-3,:);
    Pcut=P(2:end-1,1:end-3,:);

    %% Averaging

    Pavg_att = mean(Pcut_att,[1 2]);
    Pavg_att = reshape(Pavg_att,size(Pavg_att,3),1);

    Pavg = mean(Pcut,[1 2]);
    Pavg = reshape(Pavg,size(Pavg,3),1);
    %% Plotting average attenuation/intensity

    figure(55)
    hold on
    title("Average attenuation in every projection", 'FontSize', 20)
%     plot([NaN(9,1)' Pavg_att(10:end)']','-r')
    plot(Pavg_att,'-r')
    xlabel("Proj number", 'FontSize', 20 )
    ylabel("\mu", 'FontSize', 30 )
    if ~isempty(ylimit)
        ylim(ylimit_att)
    end
    hold off

    figure(56)
    hold on
    title("Average intensity in every projection", 'FontSize', 20)
    plot(Pavg,'-b')
    xlabel("Proj number", 'FontSize', 20 )
    ylabel("Intensity", 'FontSize', 20 )
    if ~isempty(ylimit)
        ylim(ylimit)
    end
    hold off
    
     %% Plotting average attenuation and intensity profile
%     
%     Prof_avg = squeeze(mean(Pcut,2));
%     Prof_att_avg = squeeze(mean(Pcut_att,2));
%     
%     figure
%     hold on
%     for i = 1:5:size(Prof_att_avg,2)
%         plot(Prof_att_avg(:,i))
%     end
% %     figure(57)
% %     hold on
% %     title("Average intensity profile in every projection", 'FontSize', 20)
% %     plot(Prof_avg,'-b')
% %     xlabel("Proj number", 'FontSize', 20 )
% %     ylabel("Intensity", 'FontSize', 20 )
% %     hold off
    
end
