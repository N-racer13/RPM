% Obstacles
O1 = [ 5 10 10 5; 3 3 0 0];
O2 = [ 0 5 5 0 ; 4.5 4.5 5 5];
O3 = [8 5.5 5.5 8 ; 7 7 6.5 6.5];
O4 = [ 0 3 3 0; 6 6 10 10];
O5 = [ 0 4 4 0 ; 4.5 4.5 4 4];
O6 = [ 0 3 3 0 ; 4 4 3.5 3.5];
O7 = [8.5 5.5 5.5 8.5 ; 7.5 7.5 7 7];

O = cell(1,2);
O{1,1} = O1;
O{1,2} = O2;
O{1,3} = O3;
O{1,4} = O4;
O{1,5} = O5;
O{1,6} = O6;
O{1,7} = O7;

for i = 1:numel(O)
    O_i = O{1,i};
    patch(O_i(1, :), O_i(2, :), 'green'); hold on;
end

% Control point initial and and goal position
qi = [ 1 ; 2 ; -pi/4 ];
qg = [ 8 ; 9 ; pi/4 ];
plot(qg(1), qg(2), 'or');

% control points in body frame
cp = [0.5 -0.5 -0.5 0.5; 0.2 0.1 -0.2 -0.1];
% Triangle robot
%cp = [0.5 -0.5 0; 0 0 0.5];

% Potential field function
[q, cp] = RB_potential_field(qi, qg, O, cp);

% Plot new control points
for i = 1:numel(cp)
    Cnew = cp{i};
    patch(Cnew(1,:), Cnew(2,:), 'blue'); hold on;
    pause(0.01);
end