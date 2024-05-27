function [path,goal_found] = NeedleRRT(qI,qG,Obs,tipdim,vel,alpha,step_size,max_num_branches,xmin,xmax,ymin,ymax)
    
    %figure('WindowState','fullscreen')
    figure
    hold on
    title('RRT')
    for i = 1:length(Obs)
        patch(Obs{i}(1,:),Obs{i}(2,:),'yellow')
    end
    plot(qI(1),qI(2),"m*")
    plot(qG(1),qG(2),"r*")
    
    path = [];
    states = [qI];
    prevState = [1];
    prevAction = [0;0];
    goal_found = false;
    for i = 1:max_num_branches
        [q_idx,path,dt] = ClosestNodeAndPath(states, qG,vel,alpha,step_size,tipdim);
        prevSize = size(states,2);
        [states, prevState, prevAction,hit] = GrowBranch(states, prevState, prevAction, tipdim, Obs, q_idx, vel, alpha, path, dt);
        if ~hit
            goal_found = true;
            disp('goal found')
            break  
        end
        if size(states,2) == prevSize
            qR = [];
            min_dist = Inf;
            while min_dist == Inf
                qR = rand([3,1]).*[abs(xmax-xmin);abs(ymax-ymin);2*pi] - [(xmax-xmin)/2;(ymax-ymin)/2;pi];
                for j = 1:length(Obs)
                    [~, d1] = ClosestPointOnPolygonToPoint(qR([1,2]),Obs{j});
                    if d1 <= 0
                        min_dist = Inf;
                        break
                    end
                    if d1 < min_dist
                        min_dist = d1;
                    end
                end
            end
            [q_idx,path,dt] = ClosestNodeAndPath(states, qR,vel,alpha,step_size,tipdim);
            [states, prevState, prevAction] = GrowBranch(states, prevState, prevAction, tipdim, Obs, q_idx, vel, alpha, path, dt);
        end
    end
    path = [];
    if goal_found
        node = size(states,2);
        mod = 'g';
    else
        node = ClosestNodeAndPath(states,qG,vel,alpha,step_size,tipdim);
        mod = 'y';
    end
    while(node ~= prevState(node))
        path = [path,prevAction(:,node)];
        node = prevState(node);
    end
    path = flip(path,2);
    plotNeedle(qI,path,tipdim,vel,alpha,mod);
    
    plot(qI(1),qI(2),"m*")
    plot(qG(1),qG(2),"r*")
    axis equal
    hold off
end