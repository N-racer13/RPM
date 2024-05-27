function [len, path] = LRL(qI,qG,r)
    len = [Inf;Inf;Inf];
    path = [1;-1;1];
    circ1 = qI([1,2]) + r*[cos(qI(3)+(pi/2));sin(qI(3)+(pi/2))];
    circ2 = qG([1,2]) + r*[cos(qG(3)+(pi/2));sin(qG(3)+(pi/2))];
    V1 = circ2-circ1;
    D = vecnorm(V1);
    theta = atan2(V1(2),V1(1))-acos(D/(4*r));
    circ3 = circ1 + 2*r*[cos(theta);sin(theta)];
    V0 = qI([1,2])-circ1;
    V0 = V0/vecnorm(V0);
    V2 = circ3-circ1;
    V2 = V2/vecnorm(V2);
    V3 = circ2-circ3;
    V3 = V3/vecnorm(V3);
    V4 = qG([1,2])-circ2;
    V4 = V4/vecnorm(V4);

    len(1) = ArcLength(V0,V2,r,1);
    len(2) = ArcLength(-V2,V3,r,-1);
    len(3) = ArcLength(-V3,V4,r,1);

    len(abs(len)==r*pi*2) = 0;
    path = path(len~=0);
    len = abs(len(len~=0));
end