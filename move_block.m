function res = move_block(block, img, calib)
% MOVE_BLOCK Returns the commands to move the specified blocks to their target position.
%
%    Inputs:
%        blocks: a cell array of string values that determine which blocks you should move 
%                and in which order. For example, if blocks = {"red", "green", "blue"} 
%                that means that you need to first move red block. 
%                Your function should at minimum work for the following values of blocks:
%                blocks = {"red"}, blocks = {"green"}, blocks = {"blue"}.
%        img: an image containing the current arrangement of robot and blocks.
%        calib: calibration results from function calibrate.
%
%    Output:
%        res: robot commands separated by ";". 
%             An example output: "go(20); grab(); turn(90);  go(-10); let_go()"

% TODO:
% Something happens here which results to coordinates used for moving
% ...


% Locations of robot, cube, and target:
robot_loc_blue = [2,7,12];
robot_loc_red = [3,5,12];
cube_loc = [1,20,5];
target_loc = [0,1,0];

% plot
hold on
plot(robot_loc_red(1), robot_loc_red(2), 'r*')
plot(robot_loc_blue(1), robot_loc_blue(2), 'b*')
plot(cube_loc(1), cube_loc(2), 'rs')
plot(target_loc(1), target_loc(2), 'ro')

% 1) Calculate distance between robot and target cube
dist = calculate_distance(robot_loc_blue, cube_loc);

% 2) Calculate robot's orientation in relation to the target cube
alpha = calculate_orientation(robot_loc_blue, robot_loc_red, cube_loc);

% 3) Turn robot straight to the target cube -> "turn(alpha)"
% 4) Move robot to the target cube -> "go(dist)"
% 5) Grab cube -> "grab()"
command = "turn(" + num2str(alpha) + "); go dist(" + num2str(dist) + "); grab(); ";

% 6) Calculate robot's new location:
rob_loc_blue = robots_new_location(robot_loc_blue, dist, alpha);
rob_loc_red = robots_new_location(robot_loc_red, dist, alpha);
plot(rob_loc_red(1), rob_loc_red(2), 'r*')
plot(rob_loc_blue(1), rob_loc_blue(2), 'b*')
% TODO: korjaa pisteiden välinen ero oikeaksi

% 7) Calculate distance between robot and target circle
dist = calculate_distance(robot_loc_blue, target_loc);

% 8) Calculate robot's orientation in relation to the target circle
alpha = calculate_orientation(robot_loc_blue, robot_loc_red, target_loc); 

% 9) Turn robot straight to the target circle -> "turn(alpha)"
% 10) Move robot to the target circle -> "go(dist)"
% 11) Drob the cube -> "let_go()"
% 12) Move back from the cube (so for the next rotation the robot doesn't
% push the cube) -> go(-10)
command = command + "turn(" + num2str(alpha) + "); go(" + num2str(dist) + "); let_go(); go(-10);";
res = [command];
end