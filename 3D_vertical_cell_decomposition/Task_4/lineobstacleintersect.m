function P = lineobstacleintersect(line,O)
    %returns points where a line segment intersects any of the edges of the
    %obstacle
    %the line segment has finite length and can be contained within the
    %obstacle or it can intersect with one edge without passing through to the
    %other side of the obstacle
    P = [];
    for i = 1:size(O,2)
        j = i+1;
        if i == size(O,2)
            j = 1;
        end
        P = [P,lineintersect(line,O(:,[i,j]))];
    end
    if ~isempty(P)
        [~,idx] = sort(P(1,:));
        P = P(:,idx);
        [~,idx] = sort(P(2,:));
        P = P(:,idx);
        P = unique(P.','rows').';
    end
end