function [len, path] = DubinsPath(qI,qG,r)
    %source for algorithm
    %https://gieseanw.wordpress.com/2012/10/21/a-comprehensive-step-by-step-tutorial-to-computing-dubins-paths/
    path = [];
    len = [Inf];
    cIR = qI([1,2]) + r*[cos(qI(3)-(pi/2));sin(qI(3)-(pi/2))];
    cIL = qI([1,2]) + r*[cos(qI(3)+(pi/2));sin(qI(3)+(pi/2))];
    cGR = qG([1,2]) + r*[cos(qG(3)-(pi/2));sin(qG(3)-(pi/2))];
    cGL = qG([1,2]) + r*[cos(qG(3)+(pi/2));sin(qG(3)+(pi/2))];
    
    DRR = vecnorm(cIR-cGR);
    DLL = vecnorm(cIL-cGL);
    DRL = vecnorm(cIR-cGL);
    DLR = vecnorm(cIL-cGR);
    %test RLR
    if DRR < (4*r)
        [l,p] = RLR(qI,qG,r);
        if vecnorm(l) < vecnorm(len)
            len = l;
            path = p;
            % disp('a')
        end
    end
    %test LRL
    if DLL < (4*r)
        [l,p] = LRL(qI,qG,r);
        if vecnorm(l) < vecnorm(len)
            len = l;
            path = p;
            % disp('b')
        end
    end
    %test RSR
    if DRR > 0
        [l,p] = RSR(qI,qG,r);
        if sum(l) < sum(len)
            len = l;
            path = p;
            %disp('c')
        end
    end
    %test LSL
    if DLL > 0
        [l,p] = LSL(qI,qG,r);
        if sum(l) < sum(len)
            len = l;
            path = p;
            % disp('d')
        end
    end
    %test RSL
    if DRL >= 2*r
        [l,p] = RSL(qI,qG,r);
        if sum(l) < sum(len)
            len = l;
            path = p;
            % disp('e')
        end
    end
    %test LSR
    if DLR >= 2*r
        [l,p] = LSR(qI,qG,r);
        if sum(l) < sum(len)
            len = l;
            path = p;
            % disp('f')
        end
    end
    path = path(len>0.000000000001);
    len = abs(len(len>0.000000000001));
end