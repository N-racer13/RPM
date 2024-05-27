function [closestPoint, distance] = ClosestPointOnLineToPoint(line,point)
    %figure out which vertex of line is closer
    distances = vecnorm(line-point);
    [distances,idx] = sort(distances);

    if distances(1) == 0    %if point is equal to vertex
        closestPoint = line(:,idx(1));
        distance = 0;
        return
    end

    v1 = point-line(:,idx(1));
    v2 = line(:,idx(2))-line(:,idx(1));
    c_theta = (v1/norm(v1))'*(v2/norm(v2)); %if c_theta is negative then point is closest to vertex
    if c_theta < 0
        closestPoint = line(:,idx(1));
    else
        closestPoint = line(:,idx(1)) + norm(v1)*c_theta*v2/norm(v2); %otherwise add projection
    end
    %check half plane for sign of distance (left = neg)
    s = sign([line(2,2)-line(2,1), line(1,1)-line(1,2)]*point - (line(1,1)*line(2,2)) + (line(2,1)*line(1,2)));
    if s~=0
        distance = s*norm(closestPoint-point);
    elseif c_theta < 0
        distance = norm(closestPoint-point);
    else
        distance = 0; %point is on line
    end
end