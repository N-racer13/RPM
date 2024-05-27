function q = potential_field(CB, qI, qG)
    % Parameters
    step_size = 0.1;
    max_r = 20;
    error = 1e-5; 
    
    % Algorithm
    q = [qI];
    UI = U_att(qI, qG) + U_rep(qI, CB, max_r);
    grad = [UI];
    % Algorithm
    i = 1;
    while (norm(grad(:,i)) > error)
        q_i = q(:,i);
        grad_i = grad(:,i);
        q_i_1 = q_i - step_size * grad_i;
        delta_U = U_att(q_i_1, qG) + U_rep(q_i_1,CB,max_r);
        % Append q for full path
        q = [q, q_i_1];
        grad = [grad, delta_U];
        i = i + 1;
    end
end