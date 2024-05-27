function [closest, distance ] = closestEdgePointToPoint(edge, point)
u = dot(edge(:,1) - point, edge(:,2) - edge(:,1));
w = dot(edge(:,2) - point, edge(:,1) - edge(:,2));
% Check if on edge
if  u > 0
    closest = edge(:,1);
elseif w > 0
    closest = edge(:,2);
else
% Geometric calculation
    closest = pointOnEdge(edge, point);
end
distance = norm(point - closest);  
end
