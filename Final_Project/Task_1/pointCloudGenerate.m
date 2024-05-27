%% This function is used to create configuration space for manipulator
function [collisionMap, jointState, xe, ye] = pointCloudGenerate(linkLen, linkAng, colors, L_world, B, p_init, p_goal)
% coordinates array of end effector
xe = [];
ye = [];

% map to save collision information
collisionMap = [0];
mapIndex = 1;

% joints states array
jointState = [];

%% Create robot collision map and robot motion video
robotVideo = VideoWriter('Workspace_Pointcloud.mp4', 'MPEG-4');
robotVideo.Quality = 50; % parameter for the video
robotVideo.FrameRate = 60;
open(robotVideo);

figure(1);
hold on

for ang1 = linkAng{1}
    for ang2 = linkAng{2}
       for ang3 = linkAng{3}
          for ang4 = linkAng{4}
              jointState(:, end+1) = [ang1; ang2; ang3; ang4];
              % Plot robot motion
              [xe(end+1), ye(end+1)] = FK(linkLen, ang1, ang2, ang3, ang4);
              
              segment = drawRobot(linkLen, ang1, ang2, ang3, ang4);
              segment(end+1, :) = segment(1, :);
              segment(1, :) = [0, 0];
              for segNum = 1:size(segment, 1)-1
                  collision = isColliding(segment(segNum,:)', segment(segNum+1,:)', B);
                  if collision
                      collisionMap(mapIndex) = 1; % robot collides with obstacles in current joint state
                  end
              end
              collisionMap = logical(collisionMap);
              scatter(xe(collisionMap), ye(collisionMap), 'r.', 'linewidth', 2); % plot red end point to indicate there is collision
              scatter(xe(~collisionMap), ye(~collisionMap), 'g.', 'linewidth', 2); % plot green end point to indicate there is collision
              
              mapIndex = mapIndex+1;
              collisionMap(mapIndex) = 0; % collision map sets to 0 by default
              
              axis([L_world, L_world]);
              title(['Plotting ', num2str(size(xe, 2)), ' points']);
              xlabel('X');
              ylabel('Y');
              % Plot obstacles and points
              for i = 1:size(B,2)
                  plot(polyshape(B{i}(1,:),B{i}(2,:)), 'FaceColor', colors(i, :));
              end
              plot(p_init(1),p_init(2),'bo','MarkerSize',5)
              plot(p_goal(1),p_goal(2),'ro','MarkerSize',5)
              
              % Create animation
              drawnow;
              frame = getframe(gcf); % gcf gets the current figure handle
              writeVideo(robotVideo, frame);
              clf
          end
       end
    end
end

close(robotVideo)
close

collisionMap(end) = []; % delete the end index

end