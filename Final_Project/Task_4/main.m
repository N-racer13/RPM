clc;clear;close all
V = [-1, -1, -1,-1, 1, 1, 1, 1, 2;
    -1, -1, 1, 1, -1, -1, 1, 1, 0;
    -1, 1, -1, 1, -1, 1, -1, 1, 0];
F = {[3,1,2,4],[7,5,1,3],[4,2,6,8],[1,5,6,2],[7,3,4,8],[5,7,9],[6,5,9],[8,6,9],[7,8,9]};
V1 = V - [0;3;0];
F1 = F;
Obs1 = {V1,F1};

V2 = V + [0;3;0];
F2 = F;
Obs2 = {V2,F2};

V3 = [1,-1,-1,1;
      1,-1,1,-1;
      1,1,-1,-1]; 
F3 = {[1, 3, 2], [1, 4, 3], [1, 2, 4], [2, 3, 4]};
Obs3 = {V3,F3};

%list of objects
CB = {Obs1,Obs2,Obs3};
% CB = {};
% for i = 1:5
%     zxz = rand(3,1)*2*pi;
%     R = [cos(zxz(1)),-sin(zxz(1)),0;sin(zxz(1)),cos(zxz(1)),0;0,0,1]*[1,0,0;0,cos(zxz(2)),-sin(zxz(2));0,sin(zxz(2)),cos(zxz(2))]*[cos(zxz(3)),-sin(zxz(3)),0;sin(zxz(3)),cos(zxz(3)),0;0,0,1];
%     g = [R,(rand([3,1])*10)-5];
%     type = rand();
%     if type <= 0.5
%         v = g*[V;ones([1,size(V,2)])];
%         f = F;
%     else
%         v = g*[V3;ones([1,size(V3,2)])];
%         f = F3;
%     end
%     CB{end+1} = {v,f};
% end


%Bounds
xmin = -10;
xmax = 10;
ymin = -10;
ymax = 10;
zmin = -10;
zmax = 10;
Vbounds = [xmin xmin xmin xmin xmax xmax xmax xmax;
            ymin ymin ymax ymax ymin ymin ymax ymax;
            zmin zmax zmin zmax zmin zmax zmin zmax];
Fbounds = {[1, 2, 4, 3], [3, 4, 8, 7], [3, 7, 5, 1], [5, 7, 8, 6], [8, 4, 2, 6], [1, 5, 6, 2]};
bounds = {Vbounds,Fbounds};
% %To retrieve vertices of face j of object i
% i = 1;
% j = 9;
% CB{i}{1}(:,CB{i}{2}{j});


[Nodes, Graph] = CCD_3D([9;0;0],[-9;0;0],CB,bounds);

figure
hold on
view([1,1,1])
xlabel("X")
ylabel("Y")
zlabel("Z")
for i = 1:length(CB)
    V = CB{i}{1}.';
    F = [];
    maxlen = 0;
    for j = 1:length(CB{i}{2})
        F = [F, NaN([size(F,1),size(CB{i}{2}{j},2)-size(F,2)]);
            CB{i}{2}{j},NaN([size(CB{i}{2}{j},1),size(F,2)-size(CB{i}{2}{j},2)])];
    end

    patch('Faces',F,'Vertices',V,'FaceColor','green','linestyle','--');
end

plot3(Nodes(1,:),Nodes(2,:),Nodes(3,:),'o','MarkerFaceColor','black')
for i=1:size(Graph,2)
    for j=1:size(Graph,2)
        if Graph(i,j)~=Inf && Graph(i,j)~=0
            plot3([Nodes(1,i),Nodes(1,j)],[Nodes(2,i),Nodes(2,j)],[Nodes(3,i),Nodes(3,j)],'black')
        end
    end
end
axis equal
hold off
