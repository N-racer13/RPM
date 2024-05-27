function collision = CCDalg_2D_mod(A,O,qI,qG,r,dir,pltarc)
    %modified from https://ieeexplore.ieee.org/document/10186576
    %A is symmetrical isosceles triangle with frame at base
    %A = [w;l]
    %dir: 1=left, -1 = right
   
    %%Modifications for isosceles triangle
    collision = false;
    rin = r-A(1)/2;
    rout = max([norm([r,A(2)]);r+(A(1)/2)]);
    theta1 = qI(3) - pi/2;
    theta2 = qG(3) - pi/2 + atan(A(2)/r);
    if dir == -1
        theta1 = qG(3) + pi/2 - atan(A(2)/r);
        theta2 = qI(3) + pi/2;
    end
    if theta2 < theta1
        theta2 = theta2 + 2*pi;
    end

    % if (theta2-theta1) > pi
    %     %logic if needing to split into two cones
    %     collision = true;
    %     disp('Warning: Arc too large')
    %     return
    % end

    %cone vectors
    K = [cos(theta1) cos(theta2);sin(theta1) sin(theta2)];

    %center of curve
    M = qI([1,2]) - r*K(:,1);
    if dir == -1
        M = qI([1,2]) - r*K(:,2);
    end

    if (theta2-theta1) > pi
        %logic if needing to split into two cones
        collision = true;
        disp('Warning: Arc too large')
        plot_arc(theta1,theta2,M,rout,rin,'m');
        pause
        return
    end

    if isempty(O)
        if (pltarc == true)
            plot_arc(theta1,theta2,M,rout,rin,'c');
        end
        return
    end
    %calc edges
    Oedges = [diff(O,1,2),O(:,1)-O(:,end)];

    c=O;
    for j = [1,2]
        cond_1 = false;
        cond_2 = false;
        %cond_3 = false;
        for i = 1:size(O,2)
            ang = (K(:,j).'*Oedges(:,i))/(norm(K(:,j))*norm(Oedges(:,i)));
            if ang == -1 || ang == 1
                continue
            end
            ab = [-Oedges(:,i), K(:,j)]\(O(:,i)-M);
            if 0 <= ab(1) && ab(1) <= 1
                c = [c,M + ab(2)*K(:,j)];
                if ab(2) >= rout
                    cond_1 = true;
                end
                if ab(2) <= rin
                    cond_2 = true;
                end
                if ab(2) >= rin && ab(2) <= rout
                    %cond_3 = true;
                    collision = true;
                    return
                end
            end
        end
        if (cond_1 && cond_2) %|| cond_3
            collision = true;
            return
        end
    end

    %c = O + intersecting point
    %use half planes and convex hull to remove points outside code
    keep = true([1,size(c,2)]);
    for i = 1:size(c,2)
        %d1 = ((([1,1]/[M,M+K(:,1)])*c(:,i)) - 1)
        d1 = [-K(2,1) K(1,1)]*c(:,i) - [-K(2,1) K(1,1)]*M;
        d2 = [-K(2,2) K(1,2)]*c(:,i) - [-K(2,2) K(1,2)]*M;
        if d1 >= -0.000000001 && d2 <= 0.000000001
            keep(i) = true;
        else
            keep(i) = false;
        end
    end

    c = c(:,keep);

    if size(c,2) > 2
        c = SortVertices(c);
        %calc edges
        cedges = [diff(c,1,2),c(:,1)-c(:,end)];
    elseif size(c,2) == 2
        cedges = [diff(c,1,2),c(:,1)-c(:,end)];
    elseif size(c,2) == 1
        cedges = [0;0];
        if norm(c-M) <= rout && norm(c-M) >= rin
            collision = true;
            return
        end
    end
    %patch(c(1,:),c(2,:),'r')

    %check for line intersections across arc
    for i = 1:size(c,2)
        if norm(c(:,i)-M) >= rin && norm(c(:,i)-M) <= rout
            collision = true;
            return
        end
        if norm(c(:,i)-M) <= rin && norm(c(:,i)+cedges(:,i)-M) >= rin
            collision = true;
            return
        end
        if norm(c(:,i)-M) >= rout && norm(c(:,i)+cedges(:,i)-M) <= rout
            collision = true;
            return
        end
        if norm(c(:,i)-M) >= rout && norm(c(:,i)+cedges(:,i)-M) >= rout
            k = (cedges(:,i).'*(M-c(:,i)))/(norm(M-c(:,i))*norm(cedges(:,i))*norm(cedges(:,i)));
            q = c(:,i) + k*cedges(:,i);
            if 0 <= k && k <= 1 && norm(M-q) <= rout
                collision = true;
                return
            end
        end
    end

    if (pltarc == true)
        plot_arc(theta1,theta2,M,rout,rin,'c');
    end
    % head = [[cos(theta2 - atan(A(2)/r));sin(theta2 - atan(A(2)/r))]*[rin rout] + M,[cos(theta2 - atan(A(2)/r));sin(theta2 - atan(A(2)/r))]*r + M + [cos(qG(3));sin(qG(3))]*A(2)];
    % if dir == -1
    %     head = [[cos(theta1 + atan(A(2)/r));sin(theta1 + atan(A(2)/r))]*[rin rout] + M,[cos(theta1 + atan(A(2)/r));sin(theta1 + atan(A(2)/r))]*r + M + [cos(qG(3));sin(qG(3))]*A(2)];
    % end
    % patch(head(1,:),head(2,:),'m');
end