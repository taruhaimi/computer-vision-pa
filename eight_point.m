function F = eight_point(xL_points, xR_points)
%EIGHT_POINT eight_point function calculates the fundamental matrix F.

meanX_xL = mean(xL_points(1,:),2);
meanY_xL = mean(xL_points(2,:),2);
meanDX_xL = sum(sqrt((xL_points(1,:)-meanX_xL).^2 + (xL_points(2,:)-meanY_xL).^2))/length(xL_points);
T_L = [sqrt(2)/meanDX_xL 0 -sqrt(2)*meanX_xL/meanDX_xL;...
       0 sqrt(2)/meanDX_xL -sqrt(2)*meanY_xL/meanDX_xL;...
       0 0 1];

meanX_xR = mean(xR_points(1,:));
meanY_xR = mean(xR_points(2,:));
meanDX_xR = sum(sqrt((xR_points(1,:)-meanX_xR).^2 + (xR_points(2,:)-meanY_xR).^2))/length(xR_points);
T_R = [sqrt(2)/meanDX_xR 0 -sqrt(2)*meanX_xR/meanDX_xR;...
       0 sqrt(2)/meanDX_xR -sqrt(2)*meanY_xR/meanDX_xR;...
       0 0 1];

xL_p = [xL_points; ones(1,length(xL_points))];
xR_p = [xR_points; ones(1,length(xR_points))];

% Transform to normalized image coordinates: p_hat_L = T_L*p_L and p_hat_R
% = T_R*p_R
p_hat_L = T_L*xL_p;
p_hat_R = T_R*xR_p;

% Calculate matrix A
A = [];
for ii = 1:length(xL_points)
    A(end+1,:) = [p_hat_R(1,ii)*p_hat_L(1,ii) p_hat_R(1,ii)*p_hat_L(2,ii) p_hat_R(1,ii) p_hat_R(2,ii)*p_hat_L(1,ii) p_hat_R(2,ii)*p_hat_L(2,ii) p_hat_R(2,ii) p_hat_L(1,ii) p_hat_L(2,ii) 1];
end
[Usvd, D, V] = svd(A,'matrix');
V_rs = reshape(V(:,end),3,3)';
[Usvd2, D2, V2] = svd(V_rs,'matrix');
% Smallest singular value set equal to zero
D2(end,end) = 0;
% Calculate F_dot
F_dot = Usvd2*D2*V2';

% Denormalize
F = T_R'*F_dot*T_L;

end