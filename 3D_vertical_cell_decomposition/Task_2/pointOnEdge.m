function [edge_point] = pointOnEdge(edge, point)
edge_start = edge(:,1);
edge_end = edge(:,2);
% Vertical edge
if edge_start(1) == edge_end(1)
    edge_point = [edge_start(1); point(2)];
% Horizontal edge
elseif edge_start(2) == edge_end(2)
    edge_point = [point(1); edge_start(2)];
else
    % Geometric calculation for closest point on edge to a point
    k = (edge_end(2) - edge_start(2))/(edge_end(1) - edge_start(1));
    b = [-k*edge_start(1) + edge_start(2);(1/k)*point(1) + point(2)];
    A = [-k, 1; 1/k, 1];
    edge_point = A\b;
end
end

