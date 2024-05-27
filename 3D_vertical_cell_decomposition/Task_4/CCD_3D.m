function [V, G, n_init, n_goal] = CCD_3D(qI, qG, CB, bounds)
    %CB = Nx1 cell array of 2x1 cell array (objects)
    %CB{i}{1} = 3xM matrix of vertices
    %CB{i}{2} = 1xF cell array
    %CB{i}{2}{j} = 1xV array of indices
    %CB{i}{1}(:,CB{i}{2}{j}) = vertices of face

    %% Get the section of the space
    % Patch triangle faces
    CBTriangle = {};
    for i = 1:size(CB,2) 
        CBTriangle{end+1} = triangleDecomposition(CB{i});
    end
    boundsTriangle = {triangleDecomposition(bounds)};

    combinedTriangle = [CBTriangle, boundsTriangle];

    figure
    view([1,1,1])
    xlabel("X")
    ylabel("Y")
    zlabel("Z")
    hold on
    for i = 1:length(CBTriangle)
        V = CBTriangle{i}{1}.';
        F = [];
        for j = 1:length(CBTriangle{i}{2})
            F = [F, NaN([size(F,1),size(CBTriangle{i}{2}{j},2)-size(F,2)]);
                CBTriangle{i}{2}{j},NaN([size(CBTriangle{i}{2}{j},1),size(F,2)-size(CBTriangle{i}{2}{j},2)])];
        end
        
        for k = 1:size(F,1)
            patch('Faces',F(k, :),'Vertices',V,'FaceColor',rand(1, 3),'linestyle','--');
            pause(0.1)
        end
        
    end
    axis equal
    hold off

   %go through all vertices and save events along x axis
    events = bounds{1}(1,:);
    for i = 1:length(CB)
        events = [events,CB{i}{1}(1,:)];
    end
    %filter and sort events
    events = unique(events.','rows').';
    %first and last event can be ignored
    events = events(2:end-1);
    
    CBslices = sectionObstacle(CBTriangle, events, [1,1,1]);
    boundsslices = sectionObstacle(boundsTriangle,events,[1,1,1]);

    V = [];
    G = [];
    preveventstartidx = 1;
    for i = 1:size(events,2)
        %trim X for CB2D and bounds2D
        CB2D = {};
        for j = 1:length(CBslices{i})
            if size(CBslices{i}{j},2) < 3
                CB2D{end+1} = CBslices{i}{j}(2:3,:);
            else
                CB2D{end+1} = SortVertices(CBslices{i}{j}(2:3,:));
            end
        end
        bounds2D = boundsslices{i}{1}(2:3,:);
        if size(bounds2D,2) >= 3
            bounds2D = SortVertices(bounds2D);
        end
        %create slice graph
        [V2D, G2D] = CCD_2D(CB2D, bounds2D);

        %add X back to V2D
        V2D = [events(i)*ones([1,size(V2D,2)]);V2D];
        
        %Add slice graph to Vertices and Graph
        eventstartidx = size(V,2) + 1;
        V = [V,V2D];
        G = [G,Inf([size(G,1),size(G2D,2)]);Inf([size(G2D,1),size(G,2)]),G2D];
        
        %create edges between slice and previous slice
        for j = eventstartidx:size(V,2)
            for k = preveventstartidx:eventstartidx-1
                visible = true;
                for l = 1:length(combinedTriangle)
                    if linePolyhedronIntersection(V(:,j),V(:,k),combinedTriangle{l}{1},combinedTriangle{l}{2}) %%%%%%%%%% Nathan
                        visible = false;
                        break
                    end
                end
                if visible
                    distance = norm(V(:,j)-V(:,k));
                    G(j,k) = distance;
                    G(k,j) = distance;
                end
            end
        end
        preveventstartidx = eventstartidx;
    end

    %connect init and goal to graph
    left_cell_wall_I = max([events(events<= qI(1)),-Inf]);
    right_cell_wall_I = min([events(events>= qI(1)),Inf]);
    closestNode_I = Inf;
    minDistance_I = Inf;
    left_cell_wall_G = max([events(events<= qG(1)),-Inf]);
    right_cell_wall_G = min([events(events>= qG(1)),Inf]);
    closestNode_G = Inf;
    minDistance_G = Inf;
    for i = 1:size(V,2)
        if V(1,i) == left_cell_wall_I || V(1,i) == right_cell_wall_I
            visible = true;
            for j = 1:length(combinedTriangle)
                if linePolyhedronIntersection(qI,V(:,i),combinedTriangle{j}{1},combinedTriangle{j}{2})
                    visible = false;
                end
            end
            if visible
                distance = norm(V(:,i)-qI);
                if distance < minDistance_I
                    minDistance_I = distance;
                    closestNode_I = i;
                end
            end
        end
        if V(1,i) == left_cell_wall_G || V(1,i) == right_cell_wall_G
            visible = true;
             for j = 1:length(combinedTriangle)
                if linePolyhedronIntersection(qG,V(:,i),combinedTriangle{j}{1},combinedTriangle{j}{2})
                    visible = false;
                end
            end
            if visible
                distance = norm(V(:,i)-qG);
                if distance < minDistance_G
                    minDistance_G = distance;
                    closestNode_G = i;
                end
            end
        end
    end
    V = [V,qI,qG];
    n_init = size(V,2)-1;
    n_goal = size(V,2);
    G = [[G,Inf([size(G,1),2])];Inf([2,size(G,2)+2])];
    if minDistance_I < Inf
        G(end-1,closestNode_I) = minDistance_I;
        G(closestNode_I,end-1) = minDistance_I;
    end
    if minDistance_G < Inf
        G(end,closestNode_G) = minDistance_G;
        G(closestNode_G,end) = minDistance_G;
    end
end