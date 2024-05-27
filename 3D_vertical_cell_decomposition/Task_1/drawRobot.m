%% This function is used to draw robot segments
function segment = drawRobot(linkLen, ang1, ang2, ang3, ang4)
% Calculate robot segment coordinates respectively
segment = segmentGenerate(linkLen, ang1, ang2, ang3, ang4);

% Line segemnts to visualize robot current state
line([0; segment(:,1)], [0; segment(:,2)],'color', 'b', 'linewidth', 2);
hold on
scatter(segment(:, 1), segment(:, 2), 300, 'g.');
scatter(0, 0, 300, 'r.')
text(-5, 5, 'origin')
grid on
axis equal

end

