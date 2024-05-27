%% This function is used to determine whether a path between two joint state collides with obstacles
function isCollision = isPathColliding(linkLen, v1, v2, B)
isCollision = false;
interval = 10;

for i = 1:interval 
    vCurrent = (v2 - v1)*i/interval + v1;
    segmentCurrent = segmentGenerate(linkLen, vCurrent(1), vCurrent(2), vCurrent(3), vCurrent(4));
    if isRobotColliding(segmentCurrent, B)
        isCollision = true;
        return
    end
end

end

