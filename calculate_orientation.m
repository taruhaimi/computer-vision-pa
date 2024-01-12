function alpha = calculate_orientation(blue, red, target)
% CALCULATE_DISTANCE Returns the distance between robot and target.
%
%   Inputs:
%     blue:     3D-coordinates of robot's blue dot.
%     red:      3D-coordinates of robot's red dot.
%     target:       3D-coordinates of targets center.
%
%   Outputs:
%       alpha:      The degree of robot's rotation.

% Robot's orientation in relation to the world origo:
beta1 = atan((red(2)-blue(2))/(red(1)-blue(1)));
% Robot's orientation in relation to the target:
beta2 = atan((target(2)-blue(2))/(target(1)-blue(1)));

% The rotation angle:
alpha = beta2-beta1;
alpha = alpha*180/pi;
end