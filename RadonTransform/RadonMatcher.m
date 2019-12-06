function result = RadonMatcher(submap_radon,point_radon,initial_angle,angles)
% 影响性能的两个参数：
% gap,即采样多少个角度用于匹配,理论上越多越好,但计算量会增加
% fft结果用于计算Similar的点数,点数越多或越少结果都会越差
gap = 10;
num = 180/gap;
result = [];
for i=1:length(angles)
    score = 0;
    deg = round((angles(i) + initial_angle)*180/pi);
    for j=0:1:(num-1)
        row = deg+j*gap;
        while(row<0)
            row = row +360;
        end
        while(row>359)
            row = row - 360;
        end
        if(row>179)
            row = row -180;
            scan_vec = fliplr(submap_radon(row+1,:));
        else
            scan_vec = submap_radon(row+1,:);
        end
        point_vec = point_radon(j+1,:);
        point_fft = abs(fft(point_vec));
        scan_fft = abs(fft(scan_vec));
        score = score +  Similar(point_fft(1:15),scan_fft(1:15));
%         score = score +  0.9*Similar(point_fft(1:15),scan_fft(1:15)) + 0.1*Similar(point_vec,scan_vec);
%         score = score +  Similar(point_vec,scan_vec);
    end
    result = [result;score/num];
end
end


function score = Similar(point_vec,scan_vec)
scan_vec_norm = norm(scan_vec);
point_vec_norm = norm(point_vec);
normalization = scan_vec_norm*point_vec_norm;
if(normalization<0.0001)
    score = 1;
else
    score = point_vec*scan_vec'/ normalization;
end
end
