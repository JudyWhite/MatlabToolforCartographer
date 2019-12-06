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

