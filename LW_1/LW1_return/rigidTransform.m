function [P_t] = rigidTransformation(P, R, t)
    P_t = (P*R)+t;
end