%% This function is used to find the intersectoin point of the given segment and plane
function [pointSegmentIntersect, isIntersect] = segmentIntersect(point1, point2, x)
% Plane not intersects with the segment
pointSegmentIntersect = NaN(3,1);
isIntersect = false;
% Plane intersects with the segment at the middle
if x < max(point1(1), point2(1)) && x > min(point1(1), point2(1))
    pointSegmentIntersect = point1 + (x - point1(1))/(point2(1) - point1(1)) * (point2 - point1);
    isIntersect = true;
    return
% Segment on the plane
elseif x == max(point1(1), point2(1)) && x == min(point1(1), point2(1))
    pointSegmentIntersect = point1;
    isIntersect = true;
    return
% Plane intersects with the segment at the vertex
elseif x == max(point1(1), point2(1)) || x == min(point1(1), point2(1))
    [~, findIndex] = find([point1(1), point2(1)] == x);
    if findIndex == 1
        pointSegmentIntersect = point1;
    else
        pointSegmentIntersect = point2;
    end
    isIntersect = true;
    return
end

end

