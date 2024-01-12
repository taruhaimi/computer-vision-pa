function [output] = plot_frame(T)
%PLOT_FRAME Plots the coordinate system (a frame) given as a homogeneous
% matrix. Unit length axes is plotted starting from the origin of the
% coordinate system. X-axis is colored red, Y-axis is colored green and
% Z-axis is colored blue.
%   INPUTS: T is a homogeneous matrix
%   OUTPUTS: output is plot of X, Y and Z axis from the given matrix
%fh = figure;
%hold on;
%grid on;
% Corrected the rows to columns according to the feedback
s = inputname(1);
quiver3(T(1,end),T(2,end),T(3,end),T(1,1),T(2,1),T(3,1),10,'r','LineWidth',3)
quiver3(T(1,end),T(2,end),T(3,end),T(1,2),T(2,2),T(3,2),10,'g','LineWidth',3)
quiver3(T(1,end),T(2,end),T(3,end),T(1,3),T(2,3),T(3,3),10,'b','LineWidth',3)
text(T(1,end),T(2,end),T(3,end),s);
xlabel('X')
ylabel('Y')
zlabel('Z') 
view(-20,25);
%hold off;
end