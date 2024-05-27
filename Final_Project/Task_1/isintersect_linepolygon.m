%% This function is usde to determine whether a line intersects with an obstacle
function b = isintersect_linepolygon(S, Q)
    [conv_rows, conv_cols] = size(Q);
    [seg_rows, seg_cols] = size(S);

    if seg_rows ~= 2 || seg_cols~= 2
        error('The input segment should be 2*2');
    elseif conv_rows ~= 2
        error('The input convex matrix should have 2 rows');
    end
    
    p0 = S(:, 1);
    p1 = S(:, 2);
    Q(:, end+1) = Q(:, 1); % Expand Q, the end point is the first one
    
    if p0 == p1
        [in,on] = inpolygon(p0(1),p0(2),Q(1,:),Q(2,:));
        if on == 1
           warning('Segment collapse to a point which is on the polygon');
        elseif in==1 && on~=1
            warning('Segment collapse to a point which is in the polygon');
        elseif in~=1 && on~=1
            warning('Segment collapse to a point which is out of the polygon')
        end
        b = true;
        return
    else
        tE = 0;
        tL = 1;
        ds = p1 - p0;
        for i = 1:conv_cols
            qi = Q(:, i);
            qi_1 = Q(:, i+1);
            if i~= conv_cols
                qi_2 = Q(:, i+2);
            else
                qi_2 = Q(:, 1);
            end
            ei = qi_1 - qi;
            ei_1 = qi_2 - qi_1;
            ni = [ei(2); -ei(1)];
            % Ensure ni is outward normal vector of the edge
            if dot(ni, ei_1) > 0
                ni = [-ei(2); ei(1)];
            end
            N = dot(-(p0-qi), ni);
            D = dot(ds, ni);
            if D == 0
                if N < 0
                   b = false;
                   return 
                end
            end
            t = N/D;
            if D < 0
               tE = max(tE, t);
               if tE > tL
                   b= false;
                   return
               end
            elseif D > 0
                tL = min(tL, t);
                if tL < tE
                    b = false;
                    return
                end
            end
        end
        if tE <= tL
            b = true;
            return
        else
            b = false;
            return
        end
    end
    
end

