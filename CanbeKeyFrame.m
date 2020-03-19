close all;
path = '/home/yaoshw/Downloads';
for i=1:10:3240
    pcd = importdata([path '/points/pcd_' num2str(i) '.txt']);
    if(length(pcd)<200)
        continue;
    end
    left=180;
    right=0;
    row=zeros(1,180);
    valid_point_num=0;
    ang=round(atan(pcd(:,1)./pcd(:,2))*180/pi)+90;
    nor=sqrt(sum(pcd(:,1).*pcd(:,1)+pcd(:,2).*pcd(:,2)+pcd(:,3).*pcd(:,3),2));
    for j=1:length(pcd)
        row(ang(j))=row(ang(j))+1;
        if(nor(j)>1.5)
            valid_point_num = valid_point_num+1;
        end
    end
    for j=5:175
        if(row(j)>10 && row(j+1)>10)
            if(left==180)
                left=j;
            end
            right = j+1;
        end
    end
    
    radon = RadonTransform(pcd,1,3);
    subplot 121;
    scatter3(pcd(:,1),pcd(:,2),pcd(:,3),5,[0.5 0.5 0.5],'filled','MarkerFaceAlpha',0.5);
    hold on;
    plot3([0 -cos(left*pi/180)*3],[0 sin(left*pi/180)*3],[0 0],'r','LineWidth',2);
    plot3([0 -cos(right*pi/180)*3],[0 sin(right*pi/180)*3],[0 0],'g','LineWidth',2);
    view(0,90);
    title([num2str(i) '-' num2str(right-left) '-' num2str(valid_point_num/length(pcd))]);
    hold off;
    subplot 122;
    imshow(radon);
    pause(1);
end

function radon = RadonTransform(point,gap,range)
%点云radon变换
radon = zeros(180/gap,range*100);
for i = 0:gap:179
    rotation = rotz(-i);
    transform_point = rotation*point';
    transform_point = transform_point';
    for j = 1:length(transform_point)
        index = floor((transform_point(j,1)+range)/0.02);
        if(index<0 || index>(range*100-1))
            continue;
        else
            radon(i/gap+1,index+1) = radon(i/gap+1,index+1)+1;
        end
    end
end
end