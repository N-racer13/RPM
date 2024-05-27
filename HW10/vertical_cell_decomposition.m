function [V, G, n_init, n_goal] = vertical_cell_decomposition(qI, qG, CB, bounds)
	% Create Graph
    G = addnode(graph, 2);
    G.Nodes.q = [qI, qG]';
           
    % Add limit mean points to graph
    G = addnode(G, 2);
    G.Nodes.q(3, :) = mean(bounds(:,[1, 4]), 2);
    G.Nodes.q(4, :) = mean(bounds(:,[2, 3]), 2);
    
    % Sort obstacle vertices based on x coordinate
    verts = [];
    for i = 1:length(CB)
        verts = [verts, CB{i}];
    end
    [v, index] = sort(verts(1,:), 'ascend');
    verts = verts(:, index);
    
    % Loop through vertices for cell decomposition
    for i = 1:size(verts,2)
        % Collect points for segments
        p_i = verts(:,i);
        px_i = p_i(1);
        pi_bottom = vert_intersect(px_i, bounds(:,1:2));
        pi_top = vert_intersect(px_i, bounds(:,3:4));

        % Create points of vertical intersection with obstacles
        obs_points = [];
        for i = 1:length(CB)
            obs_i = CB{i};
            obs_i = [obs_i, obs_i(:,1)];
            % Iterate over edges
            N_edges = size(obs_i,2)-1;
            for j = 1:N_edges
                vert_pi = vert_intersect(px_i, obs_i(:,j:j+1));
                if ~isnan(vert_pi)
                    obs_points = [obs_points, vert_pi];
                end
            end
        end
        % Sort and eliminate doubles (gave wrong results otherwise)
        obs_points = unique(obs_points', 'rows')';
                
        % Create segmented zones
        seg_line = [pi_bottom, obs_points, pi_top];
        Nsegs = size(seg_line, 2) - 1;
        
        % For each segment line, check which lines are not in obstacle and
        % add midpoint to graph
        for k = 1:Nsegs
            % Midpoint per segment
            seg_i = seg_line(:,k:k+1);
            p_mid = mean(seg_i, 2);
            % Check if valid
            colide = false;
            for i = 1:numel(CB)
                obs_i = CB{i};
                [inside, on_edge] = inpolygon(p_mid(1), p_mid(2), obs_i(1,:), obs_i(2,:));
                if inside && ~on_edge
                    colide = true;
                    break
                else
                    if on_edge 
                        colide = true;
                        break;
                    end
                end
            end
            if ~colide
               % Add to graph
               G = addnode(G, 1);
               G.Nodes.q(end,:) = p_mid';
            end
        end
    end
    
    % Check if graph lines intersect for 
    for i = 1:G.numnodes
        for j = [1:i-1, i+1:G.numnodes]
            intersect = false;
            for k = 1:numel(CB)
                % Use function from previous homework
                if isintersect_linepolygon(CB{k}, G.Nodes.q(i, :)', G.Nodes.q(j, :)')
                    intersect = true;
                    break;
                end
            end
            if ~intersect
                 G = G.addedge(i,j);
            end
        end
    end
    n_init = find(G.Nodes.q == qI', 1);
    n_goal = find(G.Nodes.q == qG', 1);
    V = G.Nodes.q';
    G = full(G.adjacency);
end