function path = findPath(E, V)

    if isempty(E)
        disp('No edges found. No path to retrieve.');
        path = [];
        return;
    end
    
    n = size(V, 2);
    pathIndices = [];
    currentIdx = n;
    
    % Construct a reverse path using the parent-child relationships defined in E
    while currentIdx ~= 1
        pathIndices = [currentIdx pathIndices];
        % Find the parent of the current node
        idx = find(E(:,2) == currentIdx, 1, 'last');
        if isempty(idx)
            disp('No valid path to the start was found.');
            path = [];
            return;
        end
        currentIdx = E(idx, 1);
    end
    
    pathIndices = [1 pathIndices];
    path = V(:, pathIndices);
end
