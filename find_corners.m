function [corners] = find_corners(img, N, t, k)
%FIND_CORNERS performs the corner detection based on the Harris method.
%   The function takes a gray level image img as an input, the size N of
%   local neighborhood Q and a threshold value t. Output is a vector with
%   the (x,y) coordinates of all detected corners.
k = 0.04;
n_padding = floor(N/2);
threshold = t;
L = [0;0;0];
% Compute image gradient over the entire image:
[Gx,Gy] = imgradientxy(img,'prewitt');

% Place padding in the edges of the array
coreX = padarray(Gx,[n_padding n_padding],'replicate','both');
coreY = padarray(Gy,[n_padding n_padding],'replicate','both');
for ii = 1:size(Gx,1)
    for kk = 1:size(Gx,2)
        % Loop through every point and calculate it's neighborhood
        neighborhoodX = coreX(ii:ii+2*n_padding,kk:kk+2*n_padding);
        neighborhoodY = coreY(ii:ii+2*n_padding,kk:kk+2*n_padding);
        % Use the neighborhood to calculate Harris cornerness measure R
        T = [sum(sum(neighborhoodX.^2)) sum(sum(neighborhoodX.*neighborhoodY)); sum(sum(neighborhoodX.*neighborhoodY)) sum(sum(neighborhoodY.^2))];
        R = (T(1)*T(4)-T(2)^2)-k*(T(1)+T(4))^2;
        % If the cornerness measure R exceeds the threshold, we save the
        % point and R's value
        if(R > threshold)
            L(:,end+1) = [ii;kk;R];
        end
    end
end

% Sort the points according to descending R values
L = L(:,2:end);
[temp,order] = sort(L(3,:),'descend');
sorted_L = L(:,order);

% Loop through saved points and find the other nearest points to pinpoint
% the corners
found_corners = [];
for jj = 1:length(sorted_L)
    next_corner_point = sorted_L(1:2,jj);
    x_diff = abs(next_corner_point(1) - sorted_L(1,:));
    y_diff = abs(next_corner_point(2) - sorted_L(2,:));
    distance = x_diff + y_diff;
    nearestInd = find(distance < N);
    closest_points = sorted_L(:,nearestInd);
    [max_R, max_RI] = max(closest_points(3,:));
    if(max_R > threshold)
        found_corners(:,end+1) = closest_points(1:2,max_RI);
    end
end

% Return the found corners
corners = found_corners;
end