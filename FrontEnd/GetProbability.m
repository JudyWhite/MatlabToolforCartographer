function p = GetProbability(map,point,resolution)
%% 根据输入的子图和分辨率,以插值的方式获取点point处的概率值
cellindex = round(point/resolution);
center = cellindex*resolution;
if(center(1)>point(1))
    center(1) = center(1) - resolution;
end
if(center(2)>point(2))
    center(2) = center(2) - resolution;
end
if(center(3)>point(3))
    center(3) = center(3) - resolution;
end
point1=center;
point2=center+resolution;

index1 = round(point1/resolution);
q111 = GetIndexProbability(map,index1);
q112 = GetIndexProbability(map,[index1(1) index1(2) index1(3)+1 ]);
q121 = GetIndexProbability(map,[index1(1) index1(2)+1 index1(3) ]);
q122 = GetIndexProbability(map,[index1(1) index1(2)+1 index1(3)+1 ]);
q211 = GetIndexProbability(map,[index1(1)+1 index1(2) index1(3) ]);
q212 = GetIndexProbability(map,[index1(1)+1 index1(2) index1(3)+1 ]);
q221 = GetIndexProbability(map,[index1(1)+1 index1(2)+1 index1(3) ]);
q222 = GetIndexProbability(map,[index1(1)+1 index1(2)+1 index1(3)+1 ]);

nor1=(point-point1)./(point2-point1);
nor2 = nor1.*nor1;
nor3 = nor2.*nor1;

q11 = (q111-q112)*nor3(3)*2 + (q112-q111)*nor2(3)*3 + q111;
q12 = (q121-q122)*nor3(3)*2 + (q122-q121)*nor2(3)*3 + q121;
q21 = (q211-q212)*nor3(3)*2 + (q212-q211)*nor2(3)*3 + q211;
q22 = (q221-q222)*nor3(3)*2 + (q222-q221)*nor2(3)*3 + q221;

q1 = (q11-q12)*nor3(2)*2 + (q12-q11)*nor2(2)*3 +q11;
q2 = (q21-q22)*nor3(2)*2 + (q22-q21)*nor2(2)*3 +q21;

p = (q1-q2)*nor3(1)*2 + (q2-q1)*nor2(1)*3 + q1;

end

function p = GetIndexProbability(map,index)
% 根据索引获取子图中相应位置的概率
pos = find(map(:,1)==index(1)&map(:,2)==index(2)&map(:,3)==index(3));
if(isempty(pos))
    p=0.1;
else
    p=map(pos(1),4);
end
end
