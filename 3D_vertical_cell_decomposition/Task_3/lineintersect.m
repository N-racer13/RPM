function P = lineintersect(edge,ray)
    %returns point of object edge intersection with continous line
    %if colinear, returns edge
    %both are in form [p1,p2]

    P = [];
    m1 = diff(edge(2,:))/diff(edge(1,:));
    m2 = diff(ray(2,:))/diff(ray(1,:));
    b1 = -m1*edge(1,1) + edge(2,1);
    b2 = -m2*ray(1,1) + ray(2,1);
    if abs(m1) == Inf && abs(m2) == Inf %if both vertical lines
        return
    end
    if m1 == m2 %if parallel
        return
    end
    
    %solve for intersection
    ts = [diff(edge,1,2), -diff(ray,1,2)]\(ray(:,1) - edge(:,1));
    %make sure within bounds
    if ts(1) >= 0 && ts(1) <= 1 && ts(2) >= 0 && ts(2) <= 1
        P = (diff(edge,1,2)*ts(1)) + edge(:,1);
    end

end