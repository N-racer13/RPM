function [distance] = GJKalg_2D(A,B)
    
    %Calc MinkowskiDifference and first simplex
    if isempty(A) || isempty(B)
        distance = Inf;
        return
    end
    C = MinkowskiDifference(A,B);
    shuffleorder = randperm(size(C,2));
    simplex = C(:,shuffleorder(1:3));
    simplex = SortVertices(simplex);
    while true
        
        %Get closest point on simplex and change to a line
        [closestPoint,distance,simplex] = ClosestPointOnTriangleToPoint(simplex,[0;0]);
    
        %check if [0 0] is inside/on simplex
        if distance <= 0 % collision
            distance = 0;
            break
        end
        
        %get support point
        supportPoint = SupportMapping(C,-closestPoint);

        %if not a new support point then solution is found
        if isequal(supportPoint,simplex(:,1)) | isequal(supportPoint,simplex(:,2))
            break %solution found
        end
        %add support point to simplex line to form new simplex triangle
        simplex = SortVertices([simplex,supportPoint]);
    end
end