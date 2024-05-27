function [q_idx,path,dt] = ClosestNodeAndPath(states, qG,vel,alpha,step_size,tipdim)
    r = vel/alpha;
    max_step_size = (2*pi*r/3) - atan(tipdim(2)/r);
    step_size = min([step_size,max_step_size]);
    %find closest node+path using DubinsPath as a distance metric
    q_idx = -1;
    min_dist = Inf;
    path = [];
    len = [];
    for i = 1:size(states,2)
        [l, p] = DubinsPath(states(:,i),qG,r);
        if sum(l) < min_dist 
            min_dist = sum(l);
            q_idx = i;
            path = p;
            len = l;
        end
    end
    % len
    % path
    %segment path for CCD and desired step size
    newlen = [];
    newpath = [];
    for i = 1:size(len,1)
        temp_len = len(i);
        while temp_len > step_size
            newlen = [newlen;step_size];
            newpath = [newpath; path(i)];
            temp_len = temp_len - step_size;
        end
        newlen = [newlen;temp_len];
        newpath = [newpath; path(i)];
    end
    len = newlen;
    path = newpath;

    %convert path to alphas and calc dt since vel is constant
    dt = len/vel;
end