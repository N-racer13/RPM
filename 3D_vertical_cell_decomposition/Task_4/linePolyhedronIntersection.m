function intersects = linePolyhedronIntersection(lineStart, lineEnd, vertices, faces)
    intersects = false;
    % Iterate over each face of the polyhedron
    for i = 1:numel(faces)
        faceVertices = vertices(:, faces{i});
        % Check if the line intersects with the plane of the face
        [isIntersectingPlane, intersectionPoint] = linePlaneIntersection(lineStart, lineEnd, faceVertices(:, 1), faceVertices(:, 2), faceVertices(:, 3));
        if isIntersectingPlane
            % Check if the intersection point is inside the face
            if isPointInTriangle(intersectionPoint, faceVertices(:, 1), faceVertices(:, 2), faceVertices(:, 3)) 
                % Leave plot out if unwanted
                plot3(intersectionPoint(1), intersectionPoint(2), intersectionPoint(3), 'ok', 'MarkerSize', 10); hold on;
                intersects = true;
                return;
            end
        end
    end
end