function [closestPoint, distance] = ClosestPointOnPolygonToPoint(point,C)
    
    %Calc first simplex
    shuffleorder = randperm(size(C,2));
    simplex = C(:,shuffleorder(1:3));
    simplex = SortVertices(simplex);
    for i = 1:(2*size(C,2))
        % figure
        % hold on
        % patch(C(1,:),C(2,:),'y')
        % patch(simplex(1,:),simplex(2,:),'g')
        % plot(point(1),point(2),'r*')
        % axis equal

        %Get closest point on simplex and change to a line
        [closestPoint,distance,simplex] = ClosestPointOnTriangleToPoint(simplex,point);
    
        % plot(simplex(1,:),simplex(2,:),'b','LineWidth',2)
        % plot(simplex(1,1),simplex(2,1),'r*')
        % plot(closestPoint(1),closestPoint(2),'ro')
        % plot([closestPoint(1) point(1)],[closestPoint(2) point(2)],'r')

        %check if point is inside/on simplex
        if distance <= 0 % collision
            distance = 0;
            break
        end
        
        %get support point
        supportPoint = SupportMapping(C,point-closestPoint);

        % plot(supportPoint(1),supportPoint(2),'b+')
        % hold off

        %if not a new support point then solution is found
        if isequal(supportPoint,simplex(:,1)) | isequal(supportPoint,simplex(:,2))
            break %solution found
        end
        %add support point to simplex line to form new simplex triangle
        simplex = SortVertices([simplex,supportPoint]);
    end
end