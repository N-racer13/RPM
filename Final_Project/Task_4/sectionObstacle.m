%% This function is used to generate section plane
function sectionPlane = sectionObstacle(CBTriangle, uniqueX, viewArray)
% Cell to store obstacle vertices on a plane
sectionPlane = {};
for i = 1:size(uniqueX, 2)
    sectionPlane{end+1} = {};
end

for i = 1:size(uniqueX, 2)
    
    for k = 1:size(CBTriangle, 2)
       
        % Get the vertices on section of each obstacle
        sectionPlaneObstacle = polyhedronSection(CBTriangle{k},uniqueX(i));
        allPoints = [];
        for j = 1:size(sectionPlaneObstacle, 2)
            allPoints = [allPoints, sectionPlaneObstacle{j}];
        end
        
        allPointsTranspose = unique(round(allPoints', 3), 'rows');
        allPoints = allPointsTranspose';

        % Create connected set
        if  ~isempty(sectionPlaneObstacle)
            connectedSet = sectionPlaneObstacle{1};
            connectedSet2 = sectionPlaneObstacle{1}; % Used to connect unconvex shape

            while ~isempty(intersect(connectedSet', connectedSet2', 'rows'))
                connectedSet2 = [NaN; NaN; NaN];
                for j = 1:size(sectionPlaneObstacle, 2)
                    currentPlaneObstacle = sectionPlaneObstacle{j};
                    % If new obstacle has some points in the connected set then
                    % the new obstacle can be connected into the set
                    if ~isempty(intersect(connectedSet', currentPlaneObstacle', 'rows'))
                        connectedSet = [connectedSet, currentPlaneObstacle];
                    else
                        connectedSet2 = [connectedSet2, currentPlaneObstacle];
                    end
                end
            end
            connectedSet2(:, 1) = [];
            
            connectedSetTrans = unique(connectedSet', 'rows');
            connectedSet2Trans = unique(connectedSet2', 'rows');
            connectedSet = connectedSetTrans';
            connectedSet2 = connectedSet2Trans';

            % Pass to the plane obstacle set
            connectedSet(1,:) = [];
            connectedSet = [ones(1, size(connectedSet, 2))*uniqueX(i);CCW(connectedSet)];
            sectionPlane{i}{end+1} = connectedSet;
            if ~isempty(connectedSet2)
                
                connectedSet2(1,:) = [];
                connectedSet2 = [ones(1, size(connectedSet2, 2))*uniqueX(i);CCW(connectedSet2)];
                sectionPlane{i}{end+1} = connectedSet2;
            end
        end
    end
    
    % Plot
    figure(49+i)
    hold on
    view(viewArray)
    for j = 1:size(sectionPlane{i},2)
        currentVertex = [sectionPlane{i}{j}, sectionPlane{i}{j}(:,1)];
        plot3(currentVertex(1, :), currentVertex(2, :), currentVertex(3, :), 'LineWidth', 2, 'color', 'b');  
        scatter3(currentVertex(1, :), currentVertex(2, :), currentVertex(3, :), 'r*');
    end
    title(['Section plane at x=', num2str(uniqueX(i))])

end

end

