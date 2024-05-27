%% This function is used to apply RRT algorithm
% More details about this function can be found in the report
function [RRTPath, V, E] = RRT(NumNodes, delta_q, tolerance, bias, linkLen, p_init, p_goal, pointSpace, jointState, B)

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
V = initialState;
E = [];
RRTPath = [];

% Randomly sample point
for i = 1:NumNodes
    randIndex = rand();
    % Bias random sampling process to re-orient the new state in the
    % direction of goal state
    if randIndex > bias
        qRand = [rand(); rand(); rand(); rand()]*2*pi;
    else
        qRand = goalState;
    end
    [~, qNearIdx] = nearestVertex(qRand, V);
    qNear = V(:, qNearIdx);
    dir = qRand - qNear;
    qNew = qNear + delta_q * dir / norm(dir);
    
    if ~isPathColliding(linkLen, qNear, qNew, B)
        V = [V, qNew];
        E = [E; qNearIdx, size(V, 2)]; % Add an edge between qNear and qNew

        % Check if qNew is close enough to the goal
        [xNew, yNew] = FK(linkLen, qNew(1), qNew(2), qNew(3), qNew(4));
        if norm([xNew; yNew] - p_goal) < tolerance
            if ~isPathColliding(linkLen, qNew, goalState, B)
                V = [V, goalState]; % Add the goal position as a vertex
                E = [E; size(V, 2)-1, size(V, 2)]; % Connect the last vertex to the goal
                RRTPath = findPath(E, V); % Find the path from start to goal
                break;
            end
        end
    end
end

if isempty(RRTPath)
    error('RRT can not find path to the goal point, please try again or change your goal point')
end

end


