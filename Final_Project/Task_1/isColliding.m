%% This function is used to determine whether a segment [q1,q2] collides with a obstacle cell O
function collision = isColliding(q1, q2, O)
    collision = false;
    for i = 1:size(O,2)
        if isintersect_linepolygon([q1,q2], O{i})
            collision = true;
            return
        end
    end
end

