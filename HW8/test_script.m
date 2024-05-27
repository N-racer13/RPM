% Create triangles
triangle1 = [0, 1, 2; 0, 1, 0];
triangle2 = [5, 6, 8; 0, -0.5, 0];
triangle2 = [5; 0];

indices = [1, 2, 3, 1];
point = [3; 0];

% Plot configuration
figure(1);
plot(triangle1(1, indices), triangle1(2, indices)); hold on;
%plot(triangle2(1, indices), triangle2(2,indices)); hold on;
plot(point(1), point(2), 'k*'); hold off;
axis square; grid on;
title('triangle 1')

% ClosestPointonTriangleToPoint Test
fprintf('ClosestPointonTriangleToPoint Test:\n');

[p1, voronoi1, edge1] = ClosestPointOnTriangleToPoint(triangle1, point);
fprintf('Closest point triangl 1:\n');
p1

%[p2, voronoi2, edge2] = ClosestPointOnTriangleToPoint(triangle2, point);
%fprintf('Closest point triangl 2:\n');
%p2

% GJK test
fprintf('ClosestPointonTriangleToOrigin Test:\n');

distance = GJK(triangle1, triangle2);
fprintf('Distance between triangle 1 and triangle 2 is %d', distance);