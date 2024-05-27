function [path, V, E, G] = build_RRT(q_init, q_goal, nodes, delta_q, O, X_max, Y_max, tolerance)
    % Create Graph
    G = graph;
    G = addnode(graph, 1);
    G.Nodes.q = q_init';
        
    % Loop through and add nodes
    for k = 1:nodes
        % Create random node
        q_rand = [X_max*rand; Y_max*rand];
        
        % Find nearest neighbor
        distance = vecnorm(G.Nodes.q - q_rand', 2, 2);
        [min_distance, q_index] = min(distance);
        q_near = G.Nodes.q(q_index, :)';
        
        % Calculate d_new
        q_new = q_near + delta_q*(q_rand - q_near)/norm(q_rand - q_near);
        for i = 1:numel(q_new)
            if q_new(i) < 0
                q_new(i) = 0;
            end
        end
        q_new = min(q_new, [X_max; Y_max]);
        
        % Check if already added
        if all(G.Nodes.q == q_new')
            continue;
        end
        
        % Check for object collision
        colliding = false;
        check_nodes = boolean(zeros(length(O), 1));
        for i = 1:length(O)
            check_nodes(i) = isintersect_linepolygon(O{i}, q_near, q_new);
            if check_nodes(i) == true
                colliding = true;
            end
        end
        if colliding
            continue;
        end
        
        % Add to q_new graph
        G = G.addnode(table(q_new', 'VariableNames', {'q'}));
        G = G.addedge(q_index, size(G.Nodes, 1));
        
        % Check tolerance
        if norm(q_near - q_goal) < tolerance
            G = G.addnode(table(q_goal', 'VariableNames', {'q'}));
            G = G.addedge(q_index, size(G.Nodes, 1));
            break;
        end
    end
    
    % Find path using build-in functions
    q_goal_index = find(all(G.Nodes.q == q_goal', 2));
    index_path = shortestpath(G, 1,q_goal_index(1));
    path = G.Nodes.q(index_path, :)';
    V = G.Nodes.q';
    E = table2array(G.Edges);
    
end
