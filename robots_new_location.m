function new_loc = robots_new_location(rob_loc, dist, alpha)
    new_loc(1) = rob_loc(1) + dist*cos(alpha); % x
    new_loc(2) = rob_loc(2) + dist*sin(alpha); % y
    new_loc(3) = rob_loc(3); % z (doesn't change)
end