% clear all
% close all
% clc
function [P, Patt, Pavg, Pavg_att] = TestHnc(P)



%% read image names only
if nargin == 0
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
    %% Lin attenuation

    IDark = 0;
    I0 = 2^16-1;
    Patt_0 = P-IDark; Patt_0(Patt_0<1) = 1;

    Patt_1 = log(double(Patt_0));

    Patt_2 = log(I0-IDark)*ones(size(Patt_1)); %I0 - IDark must of course be >=1

    Patt = Patt_2 - Patt_1;

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
    hold off

    figure(56)
    hold on
    title("Average intensity in every projection", 'FontSize', 20)
    plot(Pavg,'-b')
    xlabel("Proj number", 'FontSize', 20 )
    ylabel("Intensity", 'FontSize', 20 )
    hold off
    
    %% Plotting average attenuation and intensity profile
    
    Prof_avg = squeeze(mean(Pcut,2));
    Prof_att_avg = squeeze(mean(Pcut_att,2));
    
    figure
    hold on
    for i = 1:5:size(Prof_att_avg,2)
        plot(Prof_att_avg(:,i))
    end
%     figure(57)
%     hold on
%     title("Average intensity profile in every projection", 'FontSize', 20)
%     plot(Prof_avg,'-b')
%     xlabel("Proj number", 'FontSize', 20 )
%     ylabel("Intensity", 'FontSize', 20 )
%     hold off
    
end
% 
% %%
% % Pcut=P(:,2:end-1,:); %crop and avoid values in the first and last column 768-2=766
% % e^0.133516
% % Prepare Hnc header
% load hncHeaderTemplate.mat
% info = hncHeaderTemplate;
% info.uiSizeX = 766; info.uiSizeY = 1021;
% 
% % ang=linspace(0,360,613);
% 
% % Write to hnc files
% for k = 1:length(fnames);
%     % The recorded angle value follows the inverted convention of normal Hnc convention
%     info.dCTProjectionAngle = ang(k);
%     info.dCBCTPositiveAngle = mod(ang(k)+270,360);
%     HncWrite(info,Pcut(:,:,k),['.\\CroppedByMatlab\\' num2str(k,'Proj_%05d.hnc')]);
% end;
% 
% 
% %% 
% 
% % Pcut=P(:,2:end-1,:); %crop and avoid values in the first and last column 768-2=766
% % e^0.133516
% % Prepare Hnc header
% load hncHeaderTemplate.mat
% info = hncHeaderTemplate;
% info.uiSizeX = 768; info.uiSizeY = 1024;
% 
% % ang=linspace(0,360,613);
% 
% % Write to hnc files
% for k = 1:size(fnames);
%     % The recorded angle value follows the inverted convention of normal Hnc convention
%     info.dCTProjectionAngle = ang(k);
%     info.dCBCTPositiveAngle = mod(ang(k)+270,360);
%     HncWrite(info,P(:,:,k),['.\\CroppedByMatlab\\' num2str(k,'Proj_%05d.hnc')]);
% end;