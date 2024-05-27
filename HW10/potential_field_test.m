clear
close all

% Obstacle boundaries
CB{1} = [ 0 50 50  0; 25  25  50 50];
CB{2} = [80 80 70 70; 50 100 100 50];
CB = {[0 50 50  0; 25  25  50 50], [80 80 70 70; 50 100 100 50]};
% Initial and final configurations
qI = [0.5; 0.5]; qG = [95; 95];

% Calculate path
path = potential_field(CB, qI, qG);

% Figure
fig = figure(1);
for i = 1:numel(CB)
    CB_i = CB{i};
    patch(CB_i(1,:), CB_i(2,:), 'green'); hold on;
end
plot(path(1,:), path(2,:), 'k.');
hold on;
plot(qI(1), qI(2), 'b*');
hold on;
plot(qG(1), qG(2), 'g*');
hold off;