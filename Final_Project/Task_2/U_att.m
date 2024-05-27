function U_a = U_att(pt , pt_goal)
% Parameters
zeta = 0.05;
r_G = 10;
% Potential field calculation
if norm(pt - pt_goal) <= r_G
    U_a = zeta*(pt - pt_goal);
else
    U_a = zeta*r_G*(pt - pt_goal)/norm(pt - pt_goal);
end
end