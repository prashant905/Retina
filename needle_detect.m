clear;
clc;close all
tic
%%%%%%%%%%%%%%%%%configure the oct image
config = getConfigOCT();
im_count = 0;
name = 'C:\Users\PRASHANT\Documents\MATLAB\Needle_detection\4036\022.bmp';
I =imread(name);
imshow(I);
im_count = im_count + 1;
[BW_needle,needle{im_count},retina{im_count},BW_needle_BoundingBox_old{im_count},peak_point_method1{im_count},peak_point_method2{im_count}, backpoint{im_count},needle_all_index_x{im_count},needle_all_index_y{im_count},up_im_retina{im_count}] = find_peak_point_needle(I);
figure;imshow(BW_needle);
figure;imshow(I);
hold on
bb = regionprops(BW_needle, 'BoundingBox' );
thisBB = bb.BoundingBox;
rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],'EdgeColor','r','LineWidth',2 )
[peak_point_method1,peak_point_method2,BW_needle_BoundingBox,needle_all_index_x,needle_all_index_y]=shape_analysis(config,BW_needle,BW_needle_BoundingBox_old,peak_point_method1,peak_point_method2,needle_all_index_x,needle_all_index_y);
s= regionprops(BW_needle, 'BoundingBox');
handlePlot = 1;