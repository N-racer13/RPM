function [p1,p2,ns1,ns2] = Tangent(circ1,circ2)
    %c1,c2 = [x,y,r]
    
    V1 = circ2([1,2])-circ1([1,2]);
    D = vecnorm(V1);
    c1 = (circ2(3)-circ1(3));
    c2 = (circ2(3)+circ1(3));
    if D > 0
        V1 = V1/D;
        c1 = c1/D;
        c2 = c2/D;
    end

    n1 = [c1 -sqrt(1-(c1^2));sqrt(1-(c1^2)) c1]*V1;
    n2 = [c1 sqrt(1-(c1^2));-sqrt(1-(c1^2)) c1]*V1;
    n3 = [c2 -sqrt(1-(c2^2));sqrt(1-(c2^2)) c2]*V1;
    n4 = [c2 sqrt(1-(c2^2));-sqrt(1-(c2^2)) c2]*V1;
    
    valid = [isreal(n1),isreal(n2),isreal(n3),isreal(n4)];
    ns1 = [n1,n2,n3,n4].*valid;
    ns2 = [n1,n2,-n3,-n4].*valid;
    p1 = circ1([1,2])+circ1(3)*ns1;
    p2 = circ2([1,2])+circ2(3)*ns2;
end