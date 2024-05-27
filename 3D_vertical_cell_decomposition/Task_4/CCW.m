function vertices_CCW_Mink = CCW(vertices)

centroid = mean(vertices, 2);

angles = atan2(vertices(2,:) - centroid(2), vertices(1,:) - centroid(1));

% Sort points by angles
[~, sortIndices] = sort(angles);
vertices_CCW = vertices(:, sortIndices);

[~, yindex] = min(vertices_CCW(2, :));
leastIndex = find(vertices_CCW(2,:) == vertices_CCW(2, yindex));

% Find points with the least Y value
if size(leastIndex,2) ~= 1
    startPointList = vertices_CCW(:, leastIndex);
    [~, xindex] = min(startPointList(1, :));
    startPoint = startPointList(:, xindex);
else
    startPoint = vertices_CCW(:, yindex);
end

matches = all(vertices_CCW == startPoint, 1);
startIndex = find(matches);

if startIndex > 1
    vertices_CCW_Mink = zeros(size(vertices_CCW));
    vertices_CCW_Mink = vertices_CCW(:, startIndex:end);
    vertices_CCW_Mink = [vertices_CCW_Mink, vertices_CCW(:, 1:startIndex-1)];
else
    vertices_CCW_Mink = vertices_CCW;
end

end