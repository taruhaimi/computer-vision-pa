function dist = calculate_distance(robot, target)
% CALCULATE_DISTANCE Returns the distance between robot and target.
%
%   Inputs:
%     robot:   Location in 3D coordinates of the robot (blue dot)
%     target:   Location in 3D coordinates of the target (center of cube or circle)
%
%   Outputs:
%       dist:   Distance in cm between input objects

flag = 2; % 2d dist
% flag = 3; 3d dist

% Euclidean distance:
if flag == 2
    dist = sqrt( (target(1)-robot(1))^2 + (target(2)-robot(2))^2);
end
if flag == 3
    dist = sqrt( (target(1)-robot(1))^2 + (target(2)-robot(2))^2 + (target(3)-robot(3))^2);
end

% Subtracting the depth of grab (120mm) from the whole distance:
dist = dist - 12;
end