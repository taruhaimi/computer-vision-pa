% Computer Vision Practical Assignment
close all, clearvars, clc

addpath(genpath('./calibration'));
addpath(genpath('./images'));
addpath(genpath('./Ksii'));

checkerboard = imread('checkerboard.png');
cubes = imread('cubes.png');

% Own images
imds = imageDatastore('Ksii',"FileExtensions",[".png"]);
imgs = readall(imds);

%% Otettiinko yhtään kuvaa niin että viivoitin paikallaan? Tai siirrettiinkö checkerboardia ennen mittaamista?

imshow(imgs{7,1})
hold on;

% Coordinates (imgs{3,1})

clickPoints = 0;

if(clickPoints == 0)
    % Green cube
    green_coord = [573 565 521 606 615
                   680 636 616 607 650]; % [bottom-mid-front top-mid-front top-left-front
                                         % top-right-front bottom-right-front]
    red_coord = [854 853 795 798 892 892
                 872 825 797 845 782 829]; % [top-mid-front bottom-mid-front top-left-front 
                                           % bottom-left-front top-right-front bottom-right-front]
    blue_coord = [1032 1029 977 975 1059 1054
                  697 743 677 720 665 709]; % [top-mid-front bottom-mid-front top-left-front
                                % bottom-left-front top-right-front bottom-right-front
else
   
    coordinates2d = ginput(6);

end
% Real world distance from origin (red circle center) in cm [x y z]
green_real_dist = [18+(4*4.5) 18+(4*4.5) 18+(4*4.5)     18+(3*4.5)-0.4  18+(3*4.5)-0.4
                   -4.5       -4.5       -(2*4.5)-0.4   -4.5            -4.5
                   0           4.9       4.9            4.9             0];
red_real_dist = [18+(5*4.5)     18+(5*4.5)      18+(5*4.5)  18+(5*4.5)  18+(4*4.5)-0.4  18+(4*4.5)-0.4
                 (6*4.5)+0.4    (6*4.5)+0.4     (5*4.5)     (5*4.5)     (6*4.5)+0.4     (6*4.5)+0.4
                 4.9            0               4.9         0           4.9             0];
blue_real_dist = [18+(4.5)      18+(4.5)        18+(4.5)    18+(4.5)    18-0.4          18-0.4
                  (7*4.5)+0.4   (7*4.5)+0.4     (6*4.5)     (6*4.5)     (7*4.5)+0.4     (7*4.5)+0.4
                  4.9           0               4.9         0           4.9             0];


coordinates3d = [0 0 0; %red circle center (origin)
                 0 15 0; %green circle center
                 0 30 0; %blue circle center
                 18+4.5 -4.5 4.9; %green cube front right top 
                 18+4.5*3 6*4.5 4.9; %blue cube front right top 
                 18+4.5*6 7*4.5 4.9; %red cube front right top
];


% points2d = [green_coord red_coord blue_coord];
% points3d = [green_real_dist red_real_dist blue_real_dist];

% plot(points2d(1,:),points2d(2,:),'wo')
% hold off;
% 
% % Projection matrix
% M = calibrate_own(points3d, points2d, 1)

points2d = coordinates2d';
points3d = coordinates3d';

plot(points2d(1,:),points2d(2,:),'wo')
hold off;

% Projection matrix
M = calibrate_own(points3d, points2d, 1)

%%
% Decompose
[K, R, C] = decompose_projection(M)

I = eye(3);
recalculated_M = K*R*[I -C]

%T = [R -R*C];
T = [R' C];

% Plotting
figure();
plot3(points3d(1,:),points3d(2,:),points3d(3,:),'*k')
hold on;
grid on;
axis equal;
plot_frame(T)


% Exercise 6 task 3:
Origin_w_3d = [0, 0, 0, 1]';
% The rotation component must be changed from cRw to wRc. The camera center
% is already in world coordinates.
T = [R' C]; % In this R, not R' --> still not right?

% Calculating the world origin point
w_origin = M*Origin_w_3d;
w_orig_2D = [w_origin(1)/w_origin(3), w_origin(2)/w_origin(3)]; % norm:[844 537] -> should be around [837 504]

%%

project3d = [points3d;ones(1,length(points3d))];

p_hat2 = M*project3d;
p_hat2 = (p_hat2(1:2,:)) ./ (p_hat2(3,:));

% Why does it flip?
% temp = p_hat2(:,6);
% temp2 = p_hat2(:,7);
% p_hat2(:,6) = temp2;
% p_hat2(:,7) = temp;

figure();
plot(points2d(1,:),points2d(2,:),'-ro')
hold on;
plot(p_hat2(1,:),p_hat2(2,:),'--k*')

% Calculate projection error:
projection_error = sum(sqrt((points2d(1,:)-p_hat2(1,:)).^2 + (points2d(2,:)-p_hat2(2,:)).^2))/length(points2d)