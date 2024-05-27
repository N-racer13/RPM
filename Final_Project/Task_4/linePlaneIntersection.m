function [isIntersecting, intersectionPoint] = linePlaneIntersection(lineStart, lineEnd, v1, v2, v3)
    % Calculate the normal of the plane
    normal = cross(v2 - v1, v3 - v1);
    % Check if line is parallel to the plane
    if dot(normal, lineEnd - lineStart) == 0
        isIntersecting = false;
        intersectionPoint = [];
        return;
    end
    % Calculate the intersection point
    t = dot(normal, v1 - lineStart) / dot(normal, lineEnd - lineStart);
    intersectionPoint = lineStart + t * (lineEnd - lineStart);
    % Check if the intersection point is within the line segment
    isIntersecting = (t >= 0) && (t <= 1);
end