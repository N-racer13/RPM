%% This function is used to determine whether a point is in a polygon
function inside = isPointInsideObstacles(point, O)
    % Check if point is inside any of the obstacles
    for k = 1:length(O)
        if inpolygon(point(1), point(2), O{k}(1,:), O{k}(2,:))
            inside = true;
            return;
        end
    end
    inside = false;
end