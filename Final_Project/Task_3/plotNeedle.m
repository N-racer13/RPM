function plotNeedle(qI,path,tipdim,vel,alpha,mod)
    r = vel/alpha;
    rin = r-tipdim(1)/2;
    rout = r+tipdim(1)/2;

    q = qI;
    for i = 1:size(path,2)
        qNext = growUnicycle2(q,vel,alpha,path(1,i),path(2,i));
        if path(1,i) == 0
            base = [0 0; tipdim(1)/2 -tipdim(1)/2;1 1];
            A = [cos(qI(3)) -sin(q(3)) q(1); sin(q(3)) cos(q(3)) q(2)]*base;
            A = [A, [cos(qNext(3)) -sin(qNext(3)) qNext(1); sin(qNext(3)) cos(qNext(3)) qNext(2)]*base];
            A = SortVertices(A);
            patch(A(1,:),A(2,:),mod);
        else
            theta1 = q(3) - pi/2;
            theta2 = qNext(3) - pi/2;
            if path(1,i) < 0
                theta1 = qNext(3) + pi/2;
                theta2 = q(3) + pi/2;
            end
            if theta2 < theta1
                theta2 = theta2 + 2*pi;
            end
            K = [cos(theta1) cos(theta2);sin(theta1) sin(theta2)];
            M = q([1,2]) - r*K(:,1);
            if path(1,i) < 0
                M = q([1,2]) - r*K(:,2);
            end
            plot_arc(theta1,theta2,M,rout,rin,mod)
        end
        q = qNext;
    end
    base = [0 0 tipdim(2); tipdim(1)/2 -tipdim(1)/2 0;1 1 1];
    A = [cos(q(3)) -sin(q(3)) q(1); sin(q(3)) cos(q(3)) q(2)]*base;
    patch(A(1,:),A(2,:),mod);
end