function [q, cp] = RB_potential_field(qi, qg, O, Cpoints)
% Stepsize
alpha = 0.15;
% Collect points for every obstacle in 3D array
[ ~, O_num] = size(O);
for i = 1:O_num
    O_i = O{1,i};
    Opoints( : , : , i ) = [O_i , O_i( : , 1 )];
end

NumCtrl = size(Cpoints, 2);
q = qi;
cp = {};
counter = 0;
% Control points in every state are enoted with Cnew
Cnew = Cpoints;
% Start Gradient Descent
while(counter < 500)
    U = [ 0 ; 0 ; 0 ];
    % Reference point coordinates for previous state
    q_prev = q( : , size(q,2) );
    theta = q_prev(3);
    theta_goal = qg(3);
    for i = 1:1:NumCtrl
        % Transform control points to world frame
        Cpoint_i = Cpoints( : , i);
        pt = q_prev(1:2, :) + [cos(theta), -sin(theta); sin(theta), cos(theta)]*Cpoint_i;
        pt_goal = qg(1:2, :) + [cos(theta_goal), -sin(theta_goal); sin(theta_goal), cos(theta_goal)] * Cpoint_i;
        Cnew(:, i) = pt;
        % Jacobian for control points potential field
        J = [eye(2), [-Cpoint_i(1)*sin(theta); Cpoint_i(1)*cos(theta)]];
        % Potential fields
        U_r = U_rep(pt, Opoints);
        U_a = U_att(pt, pt_goal);
        U = U + transpose(J)*(U_a + U_r);
    end
    % Calculate new state
    q_next = q_prev - alpha*eye(3)*U;
    q = [q, q_next];
    cp{end+1} = Cnew;

    % Stopping criteria
    if norm( q_next - qg ) < 0.1 && norm(U) <= 1e-3
        break;
    end

    counter = counter + 1;
end
end