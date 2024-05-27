function [closestPoint, distance, closestLine] = ClosestPointOnTriangleToPoint(triangle,point)
    
    %figure out which vertex is closest and connecting edges
    distances = vecnorm(triangle-point);
    [~,idx] = sort(distances);
    %define edges with CCW orientation
    if idx(1) == 1
        line_1 = triangle(:,[3,1]);
        line_2 = triangle(:,[1,2]);
    elseif idx(1) == 2
        line_1 = triangle(:,[1,2]);
        line_2 = triangle(:,[2,3]);
    else
        line_1 = triangle(:,[2,3]);
        line_2 = triangle(:,[3,1]);
    end
    %calc closest point and distance from poth lines
    [cP_1,d_1] = ClosestPointOnLineToPoint(line_1,point);
    [cP_2,d_2] = ClosestPointOnLineToPoint(line_2,point);

    if isequal(cP_1,cP_2) %if vertex is closest point choose larger distance since one will be negative
        closestPoint = cP_1;
        [distance,i] = max([d_1,d_2]);
        if (d_1 == d_2)
            sp = SupportMapping([line_1(:,1),line_2(:,2)],point-closestPoint);
            if isequal(sp,line_1(:,1))
                closestLine = line_1;
            else
                closestLine = line_2;
            end
        elseif i == 1
            closestLine = line_1;
        else
            closestLine = line_2;
        end

    elseif abs(d_1) < abs(d_2) %chose closer point by min absolute distance
        closestPoint = cP_1;
        distance = d_1;
        closestLine = line_1;
    else
        closestPoint = cP_2;
        distance = d_2;
        closestLine = line_2;
    end

    if distance <= 0    %if distance is <= 0 then point is inside triangle
        closestPoint = point;
        distance = 0;
    end
end