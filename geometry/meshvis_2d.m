function [h1,h2] = meshvis_2d(gcrd, eles)
nele = size(eles,1);
nnode = size(gcrd,1);

hold on;
for i = 1:nele
    % Lấy tọa độ các đỉnh của hexagon
    enodes = eles(i,:);
    ecrds = gcrd(enodes,:);
    
    % Vẽ hexagon
    patch(ecrds(:,1), ecrds(:, 2), 'yellow', 'FaceAlpha', 0.5);
    
    % Hiển thị element ID tại centroid
    centroid = mean(ecrds);
    text(centroid(1), centroid(2), num2str(i), 'Color', 'red', 'FontSize', 16);
end
% Hiển thị node ID tại các vertices
h1 = plot(gcrd(:,1), gcrd(:,2), 'ko', 'MarkerSize', 5, 'MarkerFaceColor', 'black');
h2 = text(gcrd(:,1), gcrd(:,2), num2str((1:nnode)'), 'Color', 'black', 'FontSize', 16);

% Thiết lập đồ thị
axis equal; axis image; box on;
xlabel('X');
ylabel('Y');
title('Lưới Hexagon');
hold off;