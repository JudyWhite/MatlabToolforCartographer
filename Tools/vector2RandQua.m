%% 根据向量vec1和vec2计算之间的旋转矩阵R, 使得R*vec1 = vec2
function [R,q] = vector2RandQua(vec1,vec2)
v1=[vec1(1) vec1(2) vec1(3)];
v2=[vec2(1) vec2(2) vec2(3)];

%转为单位向量
nv1 = v1/norm(v1);
nv2 = v2/norm(v2);

if norm(nv1+nv2)==0
    q = [0 0 0 0];
else
    u = cross(nv1,nv2);         
    u = u/norm(u);
    
    theta = acos(sum(nv1.*nv2))/2;
    q = [cos(theta) sin(theta)*u];
end

%由四元数构造旋转矩阵
R = quat2rotm(q);
end
