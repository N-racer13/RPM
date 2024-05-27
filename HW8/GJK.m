function [distance, pk] = GJK(A, B)
    % C convex hull
    C = Minkowski(A, -B);
    V = C(:,1:3);
    % Max iterations
    N = 100;
    for k = 1:N
        % Calculate closest point
        [pk, vor, edge] = ClosestPointOnTriangleToPoint(V, [0; 0]);
        % 0 if origin
        if all(pk == 0) || any(ismember(V', [0, 0], 'rows'))
            distance = 0;
            return
        end
        % Use ClosestPointOnTriangleToPoint to find Qk
        if vor.a
            Qk = V(:,[1, 2]);
        elseif vor.b
            Qk = V(:,[2, 3]);
        elseif vor.c
            Qk = V(:,[3, 1]);
        elseif edge.ab
            Qk = V(:,[1, 2]);
        elseif edge.bc
            Qk = V(:,[2, 3]);
        elseif edge.ca
            Qk = V(:,[3, 1]);
        end
        % Look for supporting point
        qk = support_mapping(C, pk);
        % If qk in Qk terminate
        if any(ismember(Qk', qk', 'rows'))
            distance = norm(pk);
            return
        end
        V = [Qk, qk]; 
    end
end
