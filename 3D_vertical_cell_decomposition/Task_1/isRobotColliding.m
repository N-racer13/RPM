%% This function is used to determine whether robot collides with obstacles
function robotCollision = isRobotColliding(segment, B)
robotCollision = false;
% Construct planar robot segment
segment(end+1, :) = segment(1, :);
segment(1, :) = [0, 0];

for segNum = 1:size(segment, 1)-1
      collision = isColliding(segment(segNum,:)', segment(segNum+1,:)', B);
      if collision
          robotCollision = true;
          return
      end
end

end

