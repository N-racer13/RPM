function [closest_point, distance] = closest_obs(q, obs)
    obs = [obs, obs(:,1)];
    N_edges = size(obs, 2) - 1;
    distance = +inf;
    for i = 1:N_edges
        seg = obs(:,i:i+1);
        edge = seg(:,2) - seg(:,1);
        % Check if point
        if seg(:,2) == seg(:,1)
            closest = seg(:,1);
            t = 0;
        else
        % Projection of q on edge
            proj_q_l =  (edge * edge')/(norm(edge)^2) * (q - seg(:,1));
            closest = seg(:,1) + proj_q_l;
            t = dot(edge, closest - seg(:,1))/dot(edge,edge);    
            if t < 0
                closest = seg(:,1);
            elseif t > 1
                closest = seg(:,2);
            end    
        end
        distance_i = norm(closest - q);
        % Update distance
        if distance_i < distance
            distance = distance_i;
            closest_point = closest;
        end
    end
end