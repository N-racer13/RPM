function vert_p = vert_intersect(px_i, obs_seg)
    [p, index] = sort(obs_seg(1,:), 'ascend');
    obs_seg = obs_seg(:,index);
    % Check if same
    if obs_seg(1,1) == obs_seg(1,2) 
        if obs_seg(1,1) == px_i
            vert_p = obs_seg;
        else
            vert_p = nan;
        end
        return;
    end
    % Otherwise get vertex point
    py_i = interp1(obs_seg(1,:), obs_seg(2,:), px_i);
    if ~isnan(py_i)
        vert_p = [px_i; py_i];
    else
        vert_p = nan;
    end
end