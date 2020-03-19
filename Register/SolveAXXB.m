%Rgij*X=X*Rcij,求解X,
%Rgij, Rcij均为4*4的转换矩阵
%Rgij为imu，Rcij为icp，所得Hcam2即为Hcam2×pcd→odom（imu）
function [Hcam2marker_, err] = SolveAXXB(Rgij, Rcij)
    A = [];
    n = size(Rgij,3);
    b=[];
    for i=1:n       %we have n-1 linearly independent relations between the views
        %Transformations between views
        %turn it into angle axis representation (rodrigues formula: P is
        %the eigenvector of the rotation matrix with eigenvalue 1 
        rgij = rotationMatrixToVector(Rgij(1:3,1:3,i));        
        rcij = rotationMatrixToVector(Rcij(1:3,1:3,i));        
        theta_gij = norm(rgij);
        theta_cij = norm(rcij);                        
        rngij = rgij/theta_gij;
        rncij = rcij/theta_cij;
        %Tsai uses a modified version of this         
        Pgij = 2*sin(theta_gij/2)*rngij;
        Pcij = 2*sin(theta_cij/2)*rncij;
        %Now we know that 
        %skew(Pgij+Pcij)*x = Pcij-Pgij  which is equivalent to Ax = b
        %So we need to construct vector b and matrix A to solve this
        %overdetermined system. (Note we need >=3 Views to have at least 2
        %linearly independent inter-view relations.
        A(3*(i-1)+1:i*3,1:3) = crossprod((Pgij+Pcij)');
        b(3*(i-1)+1:i*3) = Pcij-Pgij;
    end
    
    %Computing Rotation
    Pcg_prime = pinv(A)*b';
    %Computing residus
    err = A*Pcg_prime-b';
    residus_TSAI_rotation = sqrt(sum((err'*err))/(n-1));
    Pcg = 2*Pcg_prime/(sqrt(1+norm(Pcg_prime)^2));
    Rcg = (1-norm(Pcg)*norm(Pcg)/2)*eye(3)+0.5*(Pcg*Pcg'+sqrt(4-norm(Pcg)*norm(Pcg))*crossprod(Pcg));
    A = [];
    b = [];
    %Computing Translation
    for i=1:n-1
        A(3*(i-1)+1:i*3,1:3) = (Rgij(1:3,1:3,i) - eye(3));
        b(3*(i-1)+1:i*3) = Rcg*Rcij(1:3,4,i) - Rgij(1:3,4,i);
    end
    Tcg = pinv(A)*b';
    %Computing residus
    err = A*Tcg-b';
    residus_TSAI_translation = sqrt(sum((err'*err))/(n-1));
    %Estimated transformation
    Hcam2marker_ = [Rcg Tcg;[0 0 0 1]];  
    if(nargout==2)
        err = [residus_TSAI_rotation;residus_TSAI_translation];
    end
end



%Defines the crossproduct as defined in hartley and zisserman
% [e2]x   = as defined on p554 =    [   0,-e3,e2;
%                                       e3,0,-e1;  
%                                       -e2.e1.0    ]    
%
%Author:    Christian Wengert, 
%           Institute of Computer Vision
%           Swiss Federale Institute of Technology, Zurich (ETHZ)
%           wengert@vision.ee.ethz.ch
%           www.vision.ee.ethz.ch/~cwengert/
%
%Input:     a       A Vector (3x1)
%
%Output:    ax      The matrix [a]x as defined above
%
%Syntax:    ax = crossprod(a)   

function ax = crossprod(a)
    if(size(a,1) ~= 3 & size(a,2) ~= 1)
        error ('crossprod::Please specify an valid argument.');        
    end
    ax = [ 0,-a(3,1),a(2,1);a(3,1),0,-a(1,1);-a(2,1),a(1,1),0 ];
end