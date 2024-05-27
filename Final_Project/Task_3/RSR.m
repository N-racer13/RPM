function [len, path] = RSR(qI,qG,r)
    len = [Inf;Inf;Inf];
    path = [-1;0;-1];
    circ1 = [qI([1,2]) + r*[cos(qI(3)-(pi/2));sin(qI(3)-(pi/2))];r];
    circ2 = [qG([1,2]) + r*[cos(qG(3)-(pi/2));sin(qG(3)-(pi/2))];r];
    [p1, p2,n1,n2] = Tangent(circ1,circ2);
    %with RSR use 1st output
    len(1) = ArcLength(qI([1,2])-circ1([1,2]),n1(:,1),r,-1);
    len(2) = vecnorm(p2(:,1)-p1(:,1));
    len(3) = ArcLength(n2(:,1),qG([1,2])-circ2([1,2]),r,-1);
    if abs(len(1)) == r*2*pi
        len(1) = 0;
    end
    if abs(len(3)) == r*2*pi
        len(3) = 0;
    end
    
    path = path(len~=0);
    len = abs(len(len~=0));

    % for i = 1:size(len,1)
    %     if path(i) ~= 0
    %         if len(i) > r*pi
    %             len = [len(1:i-1);r*pi;len(i)-r*pi;len(i+1:end)];
    %             path = [path(1:i-1);path(i);path(i:end)];
    %         end
    %     end
    % end

end