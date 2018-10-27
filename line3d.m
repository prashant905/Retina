% clc;
% clear;close all;
function [xFitted,yFitted,sFitted] =line3d(dataset)
data_orginal = dataset;
% data_orginal =cell2mat(data_orginal);
% data(:,1) = 2.6-data_orginal(:,1)*2.6/1024;
data(:,1) = data_orginal(:,1);
% data(:,2) = data_orginal(:,2)*3/512;
data(:,2) = data_orginal(:,2);
% data(:,3) = data_orginal(:,3)*3/128;
data(:,3) = data_orginal(:,3);
x = data(:, 1);
y = data(:, 2);
sliceNumber = data(:, 3);
goodRows = y > 3;
x = x(goodRows);
y = y(goodRows);
sliceNumber = sliceNumber(goodRows);
coefficientsX = polyfit(sliceNumber, x, 1);
coefficientsY = polyfit(sliceNumber, y, 1);
sFitted = 1 : max(sliceNumber);
xFitted = polyval(coefficientsX, sFitted);
yFitted = polyval(coefficientsY, sFitted);
scatter3(data(:,1),data(:,2),data(:,3));
hold on;
plot3(xFitted,yFitted,sFitted);
% pause
return
end
% for k = 1 : length(st)
% thisBB = st(k).BoundingBox;
% boundingBoxArea = thisBB(3) * thisBB(4);
% if boundingBoxArea >800 && boundingBoxArea <3000
%     this = thisBB; 
% end
% end
% rectangle('Position', [this(1),this(2),this(3),this(4)],'EdgeColor','r','LineWidth',2 )