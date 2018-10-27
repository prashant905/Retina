%function [x,y,needle_all_x,needle_all_y] = getpeak(Image)
function [x,y] = getpeak(Image)
x =NaN;
y =NaN;
crop = NaN;
config = getConfigOCT();
im_count =0;
I =imread(Image);
im_count = im_count + 1;
level = 0.16;%0.14graythresh(I)0.19
BW = im2bw(I,level);
BW_filted = medfilt2(BW,[5 5]);
label_threshold = 250;
label_large_threshold = 6000;%3000
label_large_mem = [];
label_large_mem_number = 0;
[BW_filted_label,num]= bwlabel(BW_filted, 8);
for i=1:num
    label_index{i}=find(BW_filted_label==i);
    if length(label_index{i}) < label_threshold
        BW_filted_label(label_index{i})=0;
    end
    %%%%%%%%%%find the retina tissue part
    if length(label_index{i})>label_large_threshold
        label_large_mem_number = label_large_mem_number+1;
        label_large_mem(label_large_mem_number)=i;
    end
    %%%%%%%%%%find the retina tissue part
end
BW_filted=BW_filted_label;
img =BW_filted;
%%for 5311 type images, removing the noise 
% CC = bwconncomp(img);
% numPixels = cellfun(@numel,CC.PixelIdxList);
% for d =1:numel(numPixels)
%     pixnum = numPixels(d);
%     if pixnum >1000 && pixnum < 2000
%         img(CC.PixelIdxList{d}) = 0;
%     end
% end
%% only for image5421 else use img
% img1 = logical(img);
% img1 = bwareafilt(img1,3);
% img1 =bwareafilt(img1, [500, inf]);
%% condition to find the peak point 
binaryImage = logical(img);
binaryImage = bwareafilt(binaryImage,3);
binaryImage = bwareafilt(binaryImage, [6000, inf]);
cimg = num2cell(binaryImage,1);
ridx = cellfun(@(x) find(x,1,'first'), cimg,'un',0);
isEm = cellfun( @isempty, ridx );
dat = cell2mat( ridx(~isEm));
ridx(isEm) = {NaN} ;
dat = cell2mat(ridx);
found = ~isempty(strfind( isnan(dat), true(1,8)));
%% get peak point
if found==1
    stats = regionprops('table',img,'BoundingBox','PixelIdxList');
    for k =1:numel(stats(:,1))
        len = stats.BoundingBox(k,3);
        if len < 20
            img(stats.PixelIdxList{k})=0;
        end
    end
%      figure;imshow(img);
%     st = regionprops(bwlabel(img), 'BoundingBox' ,);
%     for k = 1 : length(st)
%         thisBB = st(k).BoundingBox;
%         boundingBoxArea = thisBB(3) * thisBB(4);
%         if boundingBoxArea >1000 && boundingBoxArea <2500;
% 	    this = thisBB;
%          xcoord = this(1)+this(3);
%          ycoord = this(2)+this(4);
%          x = (this(1)+xcoord)/2;
%          y = (this(2)+ycoord)/2;
%         
%         end
%         
%     end
%    
%     return 
    cimage = num2cell(img,1);
    idx = cellfun(@(x) find(x,1,'first'), cimage,'un',0);
    isEm = cellfun( @isempty, idx );
    data = cell2mat( idx(~isEm) );
    idx(isEm) = {NaN} ;
    data = cell2mat(idx);
    [x1,y1] =min(data);
    midX = y1-30;
    midY = x1;
    crop = imcrop(img,[midX,midY,60,130]);
    stats = regionprops(crop,'BoundingBox');
    for k = 1 : length(stats)
        thisBB = stats(k).BoundingBox;
        boundingBoxArea = thisBB(3) * thisBB(4);
        if boundingBoxArea >630 && boundingBoxArea <8000 && thisBB(2) < 2
            this = thisBB;
        end
    end
     
    xx = this(1) + this(3)/2;
    yy = this(2);
    x =midX+xx;
    y =midY+yy;
    return
else
    disp('not found');
    return
end

% if y <20
%      difference = diff(data,[],2);
%      [tippoint,index] = max(difference);
%      xdat = (index-25:index+10);
%      ydat =data(index-25:index+10);
%      [y,tip] = min(ydat);
%      x =xdat(tip);
% [q,r] =findchangepts(data,'MaxNumChanges',4,'Statistic','rms');
% for i=1:numel(q)
%     if q(i)>170 && q(i)<320
%       xdat=(q(i)-25:q(i)+25);  
%       ydat=data(q(i)-25:q(i)+25);
%       [x,tip] = min(ydat);
%       y =xdat(tip);
%     end
% end
% end
%bord_idx = sub2ind(size(img), data, 1:size(img,2));
%regs=regionprops(bwlabel(img),'pixelidxlist');
% regs_idx = struct2cell(regs);
% split_step = cellfun(@(x) sum(ismember(bord_idx,x)), regs_idx);
% split_val = split_step(split_step>0);
% split_yvals = mat2cell(ridx',split_val);
% split_xvals = mat2cell([1:size(img,2)]',split_val);
% xval =split_xvals{1};
% yval =split_yvals{1};
% yval =cell2mat(yval);
% needle(:,1) =xval;
% needle(:,2) =yval;
% needle_label = find_needle_lable(needle,BW_filted);
% [needle_all_x,needle_all_y] = find(BW_filted==needle_label);
