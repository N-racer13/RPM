%% This function is used to apply PRM algorithm
% More details about this function can be found in the report
function [PRMPath, V, G] = PRM(N, K, linkLen, p_init, p_goal, pointSpace, jointState, B)

distInitial = inf;
distGoal = inf;

%% Convert cartisian coodinates to joint states
% Find the nearest initial joint state
for i = 1:size(pointSpace, 2)
    distInitialTemp = norm(pointSpace(:, i) - p_init);
    segmentInitial = segmentGenerate(linkLen, jointState(1, i), jointState(2, i), jointState(3, i), jointState(4, i));
    if distInitialTemp<distInitial && ~isRobotColliding(segmentInitial, B)
        distInitial = distInitialTemp;
        initialState = jointState(:, i);
    end
end

% Find the nearest goal joint state
for i = 1:size(pointSpace, 2)
    distGoalTemp = norm(pointSpace(:, i) - p_goal);
    segmentGoal = segmentGenerate(linkLen, jointState(1, i), jointState(2, i), jointState(3, i), jointState(4, i));
    if distGoalTemp<distGoal && ~isRobotColliding(segmentGoal, B)
        distGoal = distGoalTemp;
        goalState = jointState(:, i);
    end
end

%% Randomly sample states
V = [initialState, goalState]; 
G = inf(N+2, N+2); % +2 for the start and goal
G(1:(N+2)+1:end) = 0;

% Randomly sample point
for i = 1:N
    stateRand = [rand(); rand(); rand(); rand()]*2*pi;
    segment = segmentGenerate(linkLen, stateRand(1), stateRand(2), stateRand(3), stateRand(4));
    while isRobotColliding(segment, B)
        stateRand = [rand(); rand(); rand(); rand()]*2*pi;
        segment = segmentGenerate(linkLen, stateRand(1), stateRand(2), stateRand(3), stateRand(4));
    end
    V = [V, stateRand];
end

for i = 1:(N+2)
    distances = vecnorm(V - V(:,i), 2, 1); % Euclidean distances
    [~, sortedIdx] = sort(distances);
    segmentCurrent = segmentGenerate(linkLen, V(1,i), V(2,i), V(3,i), V(4,i));
    for j = 2:min(K+1, length(sortedIdx)) % Start from 2 to avoid self-connection
        segmentNext = segmentGenerate(linkLen, V(1,j), V(2,j), V(3,j), V(4,j));
        if ~isPathColliding(linkLen, V(:,i), V(:, sortedIdx(j)), B) && isinf(G(i, sortedIdx(j)))
            G(i, sortedIdx(j)) = distances(sortedIdx(j));
            G(sortedIdx(j), i) = distances(sortedIdx(j)); % Graph is undirected
        end
    end
end

graphObj = graph(G, 'upper');
[pathIdx, d] = shortestpath(graphObj, 1, 2);

if isempty(pathIdx)
    PRMPath = [];
    disp('No path found.');
else
    PRMPath = V(:, pathIdx);
    disp(['Path found with Euclidean length in configuration sapce: ', num2str(d)]);
end

end