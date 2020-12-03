function [avg_aligned3] = PermutePointsCBCTtoCT(avg)

    avg_p=permute(avg,[1 3 2]); %%immagine cbct è coronale mentre ct è assiale (giro la cbct come assiale)
    avg_aligned1=imrotate(avg_p,180);

    for i=1:size(avg_aligned1,3)
        avg_aligned2(:,:,i)=avg_aligned1(:,:,end-i+1);
    end
    for i=1:size(avg_aligned1,1)
        avg_aligned3(i,:,:)=avg_aligned2(end-i+1,:,:);
    end

end