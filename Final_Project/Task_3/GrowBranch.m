function [states, prevState, prevAction,hit] = GrowBranch(states, prevState, prevAction, tipdim, Obs, q_idx, vel, alpha, path, dt)
    hit = false;
    r = vel/alpha;
    qPrev = states(:,q_idx);
    idxPrev = q_idx;
    %for each path segment
    for i = 1:size(path,1)
        qNext = growUnicycle2(qPrev,vel,alpha,path(i),dt(i));
        if path(i) ~= 0
            %collision check if curved segment
            for j = 1:length(Obs)
                if CCDalg_2D_mod(tipdim,Obs{j},qPrev,qNext,r,path(i),false)
                    hit = true;
                    return
                end
            end
            if ~hit
                CCDalg_2D_mod(tipdim,Obs{j},qPrev,qNext,r,path(i),true);
            end
        else
            %collision check if straight segment
            A = StraightNeedlePolygon(tipdim,qPrev,qNext);
            for j = 1:length(Obs)
                if GJKalg_2D(A,Obs{j}) <= 0
                    hit = true;
                    return
                end
            end
            if ~hit
                patch(A(1,:),A(2,:),'c');
            end
        end
        %add path segment to tree if there is not a collision
        states = [states, qNext];
        prevState = [prevState, idxPrev];
        prevAction = [prevAction,[path(i);dt(i)]];
        idxPrev = size(states,2);
        qPrev = qNext;
    end
end