function [gcrd,eles,L,H] = meshgen_honeycomb_hexagon(h,l,theta,nx,ny)
% generate regular hexagon mesh for honeycomb structures
% [gcrd,connections,L,H] = meshgen_honeycomb_hexagon(h,l,theta,nx,ny)
% Nhan Nguyen Minh (nhannguyenminh.vn@gmail.com)
% 2024/04/27
% Examples:
%   h = 1; % Kích thước của mỗi hexagon (mm)
%   l = h;
%   theta = 30*pi/180; % incline angle
%   nx = 17;    % odd number
%   ny = 4;     % arbitrary number
%   [gcrd,eles,L,H] = meshgen_honeycomb_hexagon(h,l,theta,nx,ny)
% ======================== Khai báo kích thước của lưới honeycomb
dx = 2*l*cos(theta); 
dy = h+2*l*sin(theta);
L = nx*dx; % Chiều dài của rectangle domain (mm)
H = h*(ny-1)/2 + dy*(ny+1)/2; % Chiều cao của rectangle domain (mm)

% ======================== GENERATE HEXAGONAL MESH
numHexagonsX = nx; 
numHexagonsY = ny;
xs = [dx/2, dx, dx, dx/2, 0, 0];
ys = [0, l*sin(theta), l*sin(theta)+h, dy, l*sin(theta)+h, l*sin(theta)];

% generate element connections and node maps
nodesMap = containers.Map('KeyType', 'char', 'ValueType', 'any');
nodeIndex = 1; % Khởi tạo chỉ số cho mỗi node duy nhất
nenode = 6; 
nele = ny*floor((nx+1)/2) + (ny-1)*floor(nx/2);
eles = zeros(nele,nenode);
cnt = 1;
for i = 1:numHexagonsX
    if mod(i,2) == 0
        jMax = numHexagonsY-1;
    else 
        jMax = numHexagonsY;
    end
    for j = 1:jMax
        % Tính tọa độ góc dưới bên trái boundingbox của mỗi hexagon
        cornerX = dx/2 * (i-1);
        cornerY = (dy+h) * (j - 1);
        % Điều chỉnh cột chẵn
        if mod(i, 2) == 0
            cornerY = cornerY + h+l*sin(theta);
        end
        % Tính tọa độ của các đỉnh hexagon
        x = zeros(6,1);
        y = zeros(6,1);
        for k = 1:6
            x(k) = cornerX + xs(k);
            y(k) = cornerY + ys(k);
        end

        % Lặp qua mỗi đỉnh của hexagon
        temp = zeros(6,1);
        for k = 1:6
            nodeKey = sprintf('%.6f,%.6f', x(k), y(k)); % Tạo khóa dựa trên tọa độ
            if ~isKey(nodesMap, nodeKey)
                nodesMap(nodeKey) = nodeIndex; % Thêm node mới
                nodeIndex = nodeIndex + 1;
            end
            temp(k) = nodesMap(nodeKey);
        end
        eles(cnt,:) = temp;
        cnt = cnt+1;
    end
end
% generate gcrd
keys = nodesMap.keys;
nnode = length(keys);
gcrd = zeros(nnode, 2);
for i = 1:length(keys)
    key = keys{i};
    temp = str2num(key);
    gcrd(nodesMap(key),:) = temp;
end