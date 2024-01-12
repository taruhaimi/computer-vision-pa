function [Q, R] = rq(M)
    [Q, R] = qr(transpose(flipud(M)));
    Q = flipud(transpose(Q));
    R = rot90(transpose(R), 2);
end