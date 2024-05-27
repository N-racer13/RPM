close all
xmax = 10;
xmin = -10;
ymax = 10;
ymin = -10;

tipdim = [0.2,0.7];
tipdim = [0.2,1];
qI = rand([3,1]).*[abs(xmax-xmin);abs(ymax-ymin);2*pi] - [(xmax-xmin)/2;(ymax-ymin)/2;pi];
qG = rand([3,1]).*[abs(xmax-xmin);abs(ymax-ymin);2*pi] - [(xmax-xmin)/2;(ymax-ymin)/2;pi];
% qI = [-10;0;0];
% qG = [10;0;0];
alpha = 2*pi;
vel = 4*pi;
step_size = 1;
max_num_branches = 500;

obs_size = 5;
n_obs = 25;
Obs = {};
while length(Obs) < n_obs
    O = SortVertices((rand([2,4])*obs_size) - (obs_size/2));
    O = O + rand([2,1]).*([abs(xmax-xmin);abs(ymax-ymin)]) - [(xmax-xmin)/2;(ymax-ymin)/2];
    [~,d1] = ClosestPointOnPolygonToPoint(qI([1,2]),O);
    [~,d2] = ClosestPointOnPolygonToPoint(qG([1,2]),O);
    if d1 > vel/alpha && d2 > vel/alpha
        Obs{end+1} = O;
    end
end

[path, success] = NeedleRRT(qI,qG,Obs,tipdim,vel,alpha,step_size,max_num_branches,xmin,xmax,ymin,ymax);


% close all
% figure('WindowState','fullscreen')
% hold on
% for i = 1:length(Obs)
%     patch(Obs{i}(1,:),Obs{i}(2,:),'yellow')
% end
% plot(qI(1),qI(2),"m*")
% plot(qG(1),qG(2),"r*")
% 
% states = [qI];
% prevState = [1];
% prevAction = [0;0];
% goal_found = false;
% for i = 1:300
%     [q_idx,path,dt] = ClosestNodeAndPath(states, qG,vel,alpha,step_size,tipdim);
%     prevSize = size(states,2);
%     [states, prevState, prevAction,hit] = GrowBranch(states, prevState, prevAction, tipdim, Obs, q_idx, vel, alpha, path, dt);
%     if ~hit
%         goal_found = true;
%         disp('goal found')
%         break  
%     end
%     if size(states,2) == prevSize
%         qR = [];
%         min_dist = Inf;
%         while min_dist == Inf
%             qR = rand([3,1]).*[abs(xmax-xmin);abs(ymax-ymin);2*pi] - [(xmax-xmin)/2;(ymax-ymin)/2;pi];
%             for j = 1:length(Obs)
%                 [~, d1] = ClosestPointOnPolygonToPoint(qR([1,2]),Obs{j});
%                 if d1 <= 0
%                     min_dist = Inf;
%                     break
%                 end
%                 if d1 < min_dist
%                     min_dist = d1;
%                 end
%             end
%         end
%         [q_idx,path,dt] = ClosestNodeAndPath(states, qR,vel,alpha,step_size,tipdim);
%         [states, prevState, prevAction] = GrowBranch(states, prevState, prevAction, tipdim, Obs, q_idx, vel, alpha, path, dt);
%         %plot(qR(1),qR(2),'d');
%     end
% end
% 
% path = [];
% if goal_found
%     node = size(states,2);
%     mod = 'g';
% else
%     node = ClosestNodeAndPath(states,qG,vel,alpha,step_size,tipdim);
%     mod = 'y';
% end
% 
% while(node ~= prevState(node))
%     path = [path,prevAction(:,node)];
%     node = prevState(node);
% end
% path = flip(path,2)
% plotNeedle(qI,path,tipdim,vel,alpha,mod);
% 
% plot(qI(1),qI(2),"m*")
% plot(qG(1),qG(2),"r*")
% axis equal
% hold off

% r = vel/alpha;
% 
% max_step_size = (pi*r) - atan(tipdim(2)/r);
% step_size = min([step_size,max_step_size]);

% figure
% hold on
% title('GJK')
% % % fill([Obs(1,:),Obs(1,1)],[Obs(2,:),Obs(1,2)],'yellow')
% % patch(Obs(1,:),Obs(2,:),'yellow')
% % plot(qI(1),qI(2),"gdiamond")
% % plot(qG(1),qG(2),"rdiamond")
% %plot circles
% 
% qI = [0;0;0];
% qG = [2;0;0];
% % plot(qI(1),qI(2),"kd")
% % plot(qG(1),qG(2),"rd")
% 
% % plotUnicycle(qI,vel,alpha,1,1,'g--');
% % plotUnicycle(qI,vel,alpha,-1,1,'r--');
% % plotUnicycle(qG,vel,alpha,1,1,'g--');
% % plotUnicycle(qG,vel,alpha,-1,1,'r--');
% 
% r = vel/alpha;
% %RSR(qI,qG,r);%
% %sum(RLR(qI,qG,r));%
% %sum(DubinsPath(qI,qG,r));%
% 
% [len,path] = DubinsPath(qI,qG,r);
% newlen = [];
% newpath = [];
% for i = 1:size(len,1)
%     temp_len = len(i);
%     while temp_len > step_size
%         newlen = [newlen;step_size];
%         newpath = [newpath; path(i)];
%         temp_len = temp_len - step_size;
%     end
%     newlen = [newlen;temp_len];
%     newpath = [newpath; path(i)];
% end
% len = newlen;
% path = newpath;
% dt = len/vel;
% 
% path = path;
% q=qI;
% Obs = [];
% for i = 1:size(path,1)
%     qPrev = q;
%     q = plotUnicycle(q,vel,alpha,path(i),dt(i),'b');
%     if path(i) ~= 0
%         hit = CCDalg_2D_mod(tipdim,Obs,qPrev,q,r,path(i),false);
%     elseif path(i) == 0
%         A = StraightNeedlePolygon(tipdim,qPrev,q);
%         if GJKalg_2D(A,Obs) <= 0
%             hit = true;
%         else
%             hit = false;
%         end
%         patch(A(1,:),A(2,:),'c');
%     end
% end
% %plotNeedle(qI,[path,dt].',tipdim,vel,alpha,'g');
% plot(qI(1),qI(2),"kd")
% plot(qG(1),qG(2),"rd")
% axis equal
% hold off



% syms thetai xi yi thetag xg yg v w1 w2 t1 t2 real;
% gi = [cos(thetai) -sin(thetai) xi; sin(thetai) cos(thetai) yi; 0 0 1];
% V1b = [0 -w1 v; w1 0 0; 0 0 0]*t1
% e1 = expm(V1b);
% g1 = simplify(gi*e1)
% g1inv = simplify(inv(g1))
% V1s = simplify(g1*V1b*g1inv)
% syms theta x y real;
% g = [cos(theta) -sin(theta) x; sin(theta) cos(theta) y; 0 0 1]
% ginv = simplify(inv(g))
% dgdx = diff(g,x)
% dgdy = diff(g,y)
% dgdtheta = diff(g,theta)
% % 
% gidgdx = ginv*dgdx
% gidgdy = ginv*dgdy
% gidgdtheta = ginv*dgdtheta
% % 
% Jb = [[gidgdx([1,2],3);gidgdx(2,1)],[gidgdy([1,2],3);gidgdy(2,1)],[gidgdtheta([1,2],3);gidgdtheta(2,1)]]
% B = [cos(theta) 0; sin(theta) 0; 0 1]
% syms us uw dt1 dt2 dt3 real
% simplify(Jb*B*[us;uw])
% e1 = expm([0 -uw us; uw 0 0; 0 0 0]*dt1)
% e2 = expm([0 0 us; 0 0 0; 0 0 0]*dt2)
% e3 = expm([0 uw us; -uw 0 0; 0 0 0]*dt3)
% gbvd = simplify(e1*e2*e3)
% bvd = simplify([gbvd([1,2],3);atan2(gbvd(2,1),gbvd(1,1))])
% g1 = simplify(g*e1)
