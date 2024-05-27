function P = lineintersect(line1,line2)
    P = [];
    %returns point of line segment intersection
    %if colinear, returns overlap segment

    %if line1 and line2 has length 0
    if isequal(line1(:,1),line1(:,2)) && isequal(line2(:,1),line2(:,2))
        if isequal(line1(:,1),line2(:,1))
            P = line1(:,1);
        end
        return
    end

    %if line1 or line2 has length 0
    if isequal(line1(:,1),line1(:,2))
        [~,d] = ClosestPointOnLineToPoint(line2,line1(:,1));
        if d == 0
            P = line1(:,1);
        end
        return
    end
    if isequal(line2(:,1),line2(:,2))
        [~,d] = ClosestPointOnLineToPoint(line1,line2(:,1));
        if d == 0
            P = line2(:,1);
        end
        return
    end

    m1 = diff(line1(2,:))/diff(line1(1,:));
    m2 = diff(line2(2,:))/diff(line2(1,:));
    b1 = -m1*line1(1,1) + line1(2,1);
    b2 = -m2*line2(1,1) + line2(2,1);
    if abs(m1) == Inf && abs(m2) == Inf %if both vertical lines
        if line1(1,1) == line2(1,1) %if colinear
            if max(line1(2,:)) < min(line2(2,:)) || max(line2(2,:)) < min(line1(2,:)) %if no overlap
                return
            end
            P = [line1,line2];
            [~,idx] = sort(P(2,:));
            P = P(:,idx([2,3]));
            if isequal(P(:,1),P(:,2)) %if single point of overlap
                P = P(:,1);
            end
            return
        else
            return
        end
    end
    if m1 == m2 %if parallel
        if b1 == b2 %if colinear
            if max(line1(2,:)) < min(line2(2,:)) || max(line2(2,:)) < min(line1(2,:)) %if no overlap
                return
            end
            P = [line1,line2];
            [~,idx] = sort(P(2,:));
            P = P(:,idx([2,3]));
            if isequal(P(:,1),P(:,2)) %if single point of overlap
                P = P(:,1);
            end
            return
        else
            return
        end
    end
    
    %solve for intersection
    ts = [diff(line1,1,2), -diff(line2,1,2)]\(line2(:,1) - line1(:,1));
    %make sure within bounds
    if ts(1) >= 0 && ts(1) <= 1 && ts(2) >= 0 && ts(2) <= 1
        P = (diff(line1,1,2)*ts(1)) + line1(:,1);
    end

end