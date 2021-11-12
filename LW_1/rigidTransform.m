function [P_t] = rigidTransormation(P, R, t)
    P_t = (P*R)+t;
end