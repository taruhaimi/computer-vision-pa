function [K, R, C] = decompose_projection(M)
    % Function decompose_projection decomposes the given projection matrix
    % into intrinsic part K, rotation R, and camera location C.
    
    X = det([M(:,2) M(:,3) M(:,4)]);
    Y = -det([M(:,1) M(:,3) M(:,4)]);
    Z = det([M(:,1) M(:,2) M(:,4)]);
    W = -det([M(:,1) M(:,2) M(:,3)]);
    %C = [X, Y, Z, W];
    %C = [X/W, Y/W, Z/W]';
    C = [X/W, Y/W, Z/W]';

    I = eye(3);
    KR = M/[I -C];

    [R, K] = rq(KR); % [R = K, Q = R]

%     B = M*[X,Y,Z,1]';
%     u = B(1);
%     v = B(2);
%     w = B(3);
% 
%     x = u/w;
%     y = v/w;
    %decomp = [K, R, C];
end