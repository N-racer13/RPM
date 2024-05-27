function collide = isintersect_linepolygon(P, q0, q1)
    % Initialize
    collide = false;
    t_E = 0; 
    t_L = 1;
    ds = q1 - q0;
    Rot = [0 1; -1 0];
    % Loop through edges
    for i = 1:size(P, 2)-1
        pi_1 = P(:,i+1);
        pi = P(:,i);
        % Calculate outward pointing normal
        ei = pi_1 - pi;
        ni = Rot * ei;
        N = -dot(q0 - pi, ni);
        D = dot(ds, ni);
        % Check if D is approximately 0
        if abs(D) < 1e-6 && N < 0
            collide = false;
            return;
        end
        % Check for non zero D
        t = N/D;
        if D > 0
            t_L = min(t_L, t);
            if t_E > t_L
                collide = false;
                return;
            end
        end
        if D < 0
            t_E = max(t_E, t);
            if t_E > t_L
                collide = false;
                return;
            end
        end
    end
    % Check if t_E <= t_L
    if t_E <= t_L
        collide = true;
        return;
    else
        collide = false;
        return;
    end
    
end
