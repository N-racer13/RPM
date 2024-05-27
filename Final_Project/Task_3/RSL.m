function [len, path] = RSL(qI,qG,r)
    len = [Inf;Inf;Inf];
    path = [-1;0;1];
    circ1 = [qI([1,2]) + r*[cos(qI(3)-(pi/2));sin(qI(3)-(pi/2))];r];
    circ2 = [qG([1,2]) + r*[cos(qG(3)+(pi/2));sin(qG(3)+(pi/2))];r];
    [p1, p2,n1,n2] = Tangent(circ1,circ2);
    %with RSL use 3rd output
    len(1) = ArcLength(qI([1,2])-circ1([1,2]),n1(:,3),r,-1);
    len(2) = vecnorm(p2(:,3)-p1(:,3));
    len(3) = ArcLength(n2(:,3),qG([1,2])-circ2([1,2]),r,1);
    if abs(len(1)) == r*2*pi
        len(1) = 0;
    end
    if abs(len(3)) == r*2*pi
        len(3) = 0;
    end
    
    path = path(len~=0);
    len = abs(len(len~=0));
end