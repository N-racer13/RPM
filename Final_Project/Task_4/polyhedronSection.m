%% This function is used to generate section of polyhedron at the given plane x = xCurrent
function obsPlane = polyhedronSection(obs,xCurrent)

obsPlane = {};
sectionPlaneObstacle = {};
V = obs{1};
F = obs{2};
for j = 1:size(F, 2)
    intersectPoint = [];
    faceCurrent = F{j};
    triangleCurrent = V(:, faceCurrent);
    triangleCurrent(:, end+1) = triangleCurrent(:, 1); % +1 to construct line segments
    pointNum = 0;
    % Get the intersection point between the edges of a triangle and
    % the plane
    for k = 1:3
        [intersectPoint(:, end+1), isIntersect] = segmentIntersect(triangleCurrent(:,k),triangleCurrent(:,k+1), xCurrent);
        if ~isIntersect 
            intersectPoint(:, end) = [];
        else
            pointNum = pointNum + 1;
        end
    end
    % If has intersection
    if ~isempty(intersectPoint)
        intersectPointNum = size(intersectPoint, 2);
        intersectPoint(:, end+1) = intersectPoint(:, end);
        intersectPoint(:, 2:end) = intersectPoint(:, 1:intersectPointNum);
        intersectPoint(:, 1) = intersectPoint(:, end);
    end
    if pointNum > 0
        obsPlaneTemp = [];
        for m = 1:pointNum
            pointSet = [intersectPoint(:, end), intersectPoint(:, end-1)];
%                 plot3(pointSet(1, :), pointSet(2, :), pointSet(3, :), 'LineWidth', 2, 'color', 'b');
            obsPlaneTemp(:, end+1) = intersectPoint(:, end);
            intersectPoint(:, end) = [];
        end
        obsPlane{end+1} = obsPlaneTemp;
    end  

end

% Trim face vertices of the intersect plane
index = [];
if ~isempty(obsPlane)
    obsCurrent = obsPlane{1};
    for p = 2:size(obsPlane, 2)
        obsCurrent = obsPlane{1};
        obsPlaneTranspose = unique(obsPlane{p}', 'rows');
        obsPlane{p} = obsPlaneTranspose';
        pointIntersect = intersect(obsCurrent', obsPlane{p}', 'rows');
        if size(pointIntersect, 1) == 2
            obsPlaneTranspose = union(obsCurrent', obsPlane{p}', 'rows');
            obsPlaneTranspose(:, 1) = [];
            % Sort new polygon in CCW
            if size(obsPlaneTranspose, 1) > 2
                obsPlane{1} = [ones(1, size(obsPlaneTranspose, 1))*xCurrent; SortVertices(obsPlaneTranspose')];
            end
            index(end+1) = p;
        end
    end

    obsPlane(index) = [];
    index2 = [];
    for p = 2:size(obsPlane, 2)
        pointIntersect = intersect(obsCurrent', obsPlane{p}', 'rows');
        if size(pointIntersect, 1) == size(obsPlane{p}, 2)
            obsPlane{p} = [];
        end
    end
    for p = 2:size(obsPlane, 2)
        if isempty(obsPlane{p})
            index2(end+1) = p;
        end
    end

    obsPlane(index2) = [];
    
end

end

