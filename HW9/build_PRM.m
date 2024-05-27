function [path, V, E, G] = build_PRM(q_init , q_goal, nodes, K, O, X_max, Y_max)  
    % Create Graph
    G = graph;
    G = addnode(graph, 2);
    G.Nodes.q = [q_init, q_goal]';
    
    % Generate non-colliding nodes
    while G.numnodes < nodes
        % Generate nodes
        q_rand = [X_max*rand; Y_max*rand];
        % Check if in obstacle
        colliding = false;
        check_nodes = boolean(zeros(length(O), 1));
        for i = 1:length(O)
            check_nodes(i) = isintersect_linepolygon(O{i}, q_rand, q_rand);
            if check_nodes(i) == true
                colliding = true;
            end
        end
       if ~colliding
           G = G.addnode(1);
           G.Nodes.q(end,:) = q_rand';
       end
    end
    
    % Add connections
    N = G.numnodes;
    for i = 1:N
        % Initilize node and nearest neighbors
        q_i = G.Nodes.q(i,:)';
        knn = knnsearch(G.Nodes.q([1:i-1, i+1:end],:), q_i', 'K', K, 'Distance', 'euclidean');
        
        % Check edge for collisions
        for j = knn
            q_j = G.Nodes.q(j,:)';
            edge_exists = G.findedge(i, j);
            if edge_exists
                continue;
            end
            colliding = false;
            check_nodes = boolean(zeros(length(O), 1));
            for k = 1:length(O)
                check_nodes(k) = isintersect_linepolygon(O{k}, q_i, q_j);
                if check_nodes(k) == true
                    colliding = true;
                end
            end  
            if ~colliding
                G = G.addedge(i, j);
            end           
        end        
    end
    
    % Find path using build-in functions
    q_goal_index = find(all(G.Nodes.q == q_goal', 2));
    index_path = shortestpath(G, 1,q_goal_index(1));
    path = G.Nodes.q(index_path, :)';
    V = G.Nodes.q';
    E = full(G.adjacency);
end