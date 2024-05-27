function [V, G] = CCD_2D(CB, bounds)
    V = [];
    G = [];
    %flip bounds so treated as a "hole" and concat with rest of obstacles
    CB = [{flip(bounds,2)},CB];
    events = []; %x coords of vertices
    vertex_type = {};
    % 0= ^,v free up
    % 1= ^,v free down
    % 2= >,< free both
    % 3 = >,< free neither
     
    for i = 1:length(CB)
        vertex_type = [vertex_type,{[]}];
        events = [events,CB{i}(1,:)];

        if size(CB{i},2) == 1
            vertex_type{i} = 2;
            continue
        end
        if size(CB{i},2) == 2
            if CB{i}(1,1) ~= CB{i}(1,2)
                vertex_type{i} = [2, 2];
                continue
            elseif CB{i}(2,1) > CB{i}(2,2)
                vertex_type{i} = [0, 1];
                continue
            elseif CB{i}(2,1) < CB{i}(2,2)
                vertex_type{i} = [1, 0];
                continue
            else
                vertex_type{i} = [2, 2];
                continue
            end
        end

        for j = 1:size(CB{i},2)
            k = j + 1;
            l = j - 1;
            if j == 1
                l = size(CB{i},2);
            elseif j == size(CB{i},2)
                k = 1;
            end
            v1 = CB{i}(:,l);
            v2 = CB{i}(:,j);
            v3 = CB{i}(:,k);
            if v1(1) == v2(1) && v2(1) == v3(1) %somehow a vertical line
                vertex_type{i} = [vertex_type{i},3];
            elseif v1(1) >= v2(1) && v2(1) >= v3(1) %top face
                if v1(1) == v2(1) && v1(2) >= v2(2) %90 down
                    vertex_type{i} = [vertex_type{i},3];
                elseif v2(1) == v3(1) && v2(2) <= v3(2) %90 up
                    vertex_type{i} = [vertex_type{i},3];
                else
                    vertex_type{i} = [vertex_type{i},0]; %type 0
                end
            elseif v1(1) <= v2(1) && v2(1) <= v3(1) %bottom face
                if v1(1) == v2(1) && v1(2) <= v2(2) %90 up
                    vertex_type{i} = [vertex_type{i},3];
                elseif v2(1) == v3(1) && v2(2) >= v3(2) %90 down
                    vertex_type{i} = [vertex_type{i},3];
                else
                    vertex_type{i} = [vertex_type{i},1]; %type 1
                end
            elseif v1(2) <= v2(2) && v2(2) <= v3(2) %right face
                if v1(1) < v2(1) %spike out
                    vertex_type{i} = [vertex_type{i},2]; %type 2
                else %spike in
                    vertex_type{i} = [vertex_type{i},3];
                end
            else %only left face left
                if v1(1) > v2(1) %spike out
                    vertex_type{i} = [vertex_type{i},2]; %type 2
                else %spike in
                    vertex_type{i} = [vertex_type{i},3];
                end
            end
        end
    end

    %filter and sort events
    events = unique(events.','rows').';
    %first and last event can be ignored
    events = events(2:end-1);
    
    for event_num = 1:size(events,2)
        line_bounds = [[events(event_num);min(bounds(2,:))],[events(event_num);max(bounds(2,:))]];
        points = [];
        descriptor = [];
        %for each obstacle (including bounds)
        for i = 1:length(CB)
            %object vertices that intersect with event
            O_points = CB{i}(2,CB{i}(1,:)==events(event_num));
            O_descriptor = vertex_type{i}(CB{i}(1,:)==events(event_num));
            %add remaining (edge intersections)
            % events(event_num)
            % line_bounds
            % CB{i}
            intersections = lineobstacleintersect(line_bounds,CB{i});
            if ~isempty(intersections)
                intersections = intersections(2,:);
            end
            for point = intersections
                if ~any(O_points == point)
                    O_points = [O_points,point];
                    O_descriptor = [O_descriptor,-1];
                end
            end
            %sort points
            [O_points,idx] = sort(O_points);
            O_descriptor = O_descriptor(idx);

            %figure out descriptions of edge intersections
            next_d = 1;
            if i == 1 %start flipped if on bounds object
                next_d = 0;
            end
            for j = 1:size(O_points,2)
                if (O_descriptor(j)) == next_d
                    next_d = ~next_d;
                elseif O_descriptor(j) == -1
                    O_descriptor(j) = next_d;
                    next_d = ~next_d;
                end
            end
            
            %logic if point is already in main list
            keep = true(size(O_points));
            for j = 1:size(O_points,2)
                for k = 1:size(points,2)
                    if O_points(j) == points(k)
                        keep(j) = false;
                        if descriptor(k) == 2 || descriptor(k) == O_descriptor(j) || O_descriptor(j) == 3
                            descriptor(k) = O_descriptor(j);
                        elseif descriptor(k) ~= O_descriptor(j) && O_descriptor(j) ~= 2
                            descriptor(k) = 3;
                        end
                        %all other cases descriptor does not change
                    end
                end
            end
            O_points = O_points(keep);
            O_descriptor = O_descriptor(keep);

            %add object intersections to main list
            points = [points,O_points];
            descriptor = [descriptor,O_descriptor];
        end
        
        %sort points
        [points, idx] = sort(points);
        descriptor = descriptor(idx);

        %logic to eliminate overlaps
        for i = 1:size(points,2)
            if descriptor(i) == 1 || descriptor(i) == 2
                if i == 1
                    descriptor(i) = 3;
                    %disp("Impossible Case 1");
                elseif descriptor(i-1) == 1 || descriptor(i-1) == 3
                    descriptor(i) = 3;
                end
            elseif descriptor(i) == 0 || descriptor(i) == 2
                if i == size(points,2)
                    descriptor(i) = 3;
                    %disp("Impossible Case 2");
                elseif descriptor(i+1) == 0 || descriptor(i+1) == 3
                    descriptor(i) = 3;
                end
            end
        end
        
        %validation loop
        for i = 1:(size(points,2)-1)
            if descriptor(i) == 0
                if descriptor(i+1) ~= 1 && descriptor(i+1) ~= 2
                    disp("Validation Error 1");
                end
            elseif descriptor(i) == 2
                if descriptor(i+1) ~= 1  && descriptor(i+1) ~= 2
                    disp("Validation Error 2");
                end
            end
        end

        %node-edge logic
        %create a node between every 0-1, 0-2, 2-2, 2-1 point
        %if vertical cell method at least 1 point must be a vertex
        %nodes with a 2 between them can be joined by an edge
        %form edges with visible nodes of adjacent event
        for i = 1:(size(points,2)-1)
            if descriptor(i) == 0 || descriptor(i) == 2
                V = [V,[events(event_num);sum(points(i:i+1))/2]];
                G = [[G,Inf([size(G,1),1])];Inf([1,size(G,2)+1])];
                if descriptor(i) == 2
                    %Can connect to the previously added node
                    distance = abs(points(i)-points(i-1));
                    G(end,end-1) = distance;
                    G(end-1,end) = distance;
                end
                %connect to all visible nodes of previous edge
                if event_num > 1
                    for j = 1:size(V,2)
                        if V(1,j) == events(event_num-1)
                            visible = true;
                            for k = 1:length(CB)
                                if ~isempty(lineobstacleintersect([V(:,j),V(:,end)],CB{k}))
                                    visible = false;
                                end
                            end
                            if visible
                                distance = norm(V(:,j)-V(:,end));
                                G(end,j) = distance;
                                G(j,end) = distance;
                            end
                        end
                    end
                end
            end
        end
    end  
end