function qG = plotUnicycle(qI,vel,alpha,action,dt,mod)
    path = qI;
    for i = 0:0.01:dt
        step = growUnicycle2(path(:,1),vel,alpha,action,i);
        path = [path,step];
    end
    qG = path(:,end);
    if i ~= dt
        qG = growUnicycle2(path(:,1),vel,alpha,action,dt);
        path = [path,qG];
    end
        plot(path(1,:),path(2,:),mod)
end