clc;
clear;
base = 'C:/Users/PRASHANT/Documents/MATLAB/Needle_detection/check/';
startfolder = 'C:/Users/PRASHANT/Documents/MATLAB/Needle_detection/image/';
base_folder =dir(startfolder);
base_folder =base_folder(arrayfun(@(x) x.name(1), base_folder) ~= '.');
Flags = [base_folder.isdir];
base_folder = base_folder(Flags);
for s =1:numel(base_folder)
    folder = base_folder(s);
    sbj=folder.name;
    disp(['Starting with folder_', sbj]);
    if isequal(sbj,'.') ||  isequal(sbj,'..')
        continue
    end
    imgfolder=fullfile(startfolder,sbj);
    showimage = fullfile([imgfolder,'/056.bmp']);
    images = dir(imgfolder);
    images =images(arrayfun(@(x) x.name(1), images) ~= '.');
    images =images(arrayfun(@(x) x.name(1), images) ~= 'e');
    images =images(arrayfun(@(x) x.name(1), images) ~= 't');
    images =images(arrayfun(@(x) x.name(1), images) ~= 'v');
    totalimage = {};
    for m =1:numel(images)
        totalimage{m} =images(m).name;
    end
    totalimage =totalimage';
    file =images(1).name;
    [pathstr,name,ext] = fileparts(file);
    name = str2num(name);
    dataset ={};
    count =1;
    aboveretina_folder = [base,sbj,'/peakpoint/'];
    if ~exist(aboveretina_folder,'dir')
            mkdir(aboveretina_folder)
    else
            disp('exist')
    end
    underretina_folder = [base,sbj,'/nopeakpoint/'];
    if ~exist(underretina_folder,'dir')
            mkdir(underretina_folder)
    else
            disp('exist')
    end
    
    for k =name+1:(length(images))
        j = images(k).name ;
        [pathstr,name,ext] = fileparts(j);
        filename = strcat(imgfolder,'\',j);
        [x,y] = getpeak(filename);
        if y <=20
            break;
        end
        if isnan(x) 
        continue;
        end
        dataset{count,1} =x;
        dataset{count,2} =y;
        dataset{count,3} =str2num(name);
        I =imread(filename);
        if y < 100
            y =101;
        end
%         if x > 480
%             y =480;
%         end
%         if x < 45
%             x =45;
%         end
         crop=imcrop(I,[x-50,y-50,120,240]);
  %       crop=imcrop(I,[x-35,3,80,1024]);
        fname1=fullfile(aboveretina_folder,j);
        imwrite(crop,fname1);
        count =count+1;
    end
    dataset =cell2mat(dataset);
    dat3 = dataset(:,3);
    startimage = dat3(1);
    ransacdata = {};
    [xFit, yFit,sFit] =line3d(dataset);
    ransacdata = xFit';
    ransacdata(:,2) = yFit';
    ransacdata(:,3) = sFit';
    ransacdata = round(ransacdata);
    ransacdata = ransacdata(1:startimage,:);
%     fname1 = sprintf('%s.mat',sbj);
%     save_folder = fullfile([base,fname1]);
%     save (save_folder,'dataset');
%     dat = dataset(:,1);
%     dat(:,2) = dataset(:,2);
%     dat =cell2mat(dat);
%     plotPoints(dat,showimage);
%     ransac_data = RANSAC(dat,8);
%     figure;imshow(showimage);
%     hold on;
%     plot(ransac_data(:,1),ransac_data(:,2), '+', 'Color', 'g');
%     plot(ransac_data(:,1),ransac_data(:,2), 'c-', 'LineWidth', 2);
%     hold off;
% Sort in order of increasing y
%     y = ransac_data(:,2);
%     x = ransac_data(:,1);
%     [sortedY, sortOrder] = sort(y);
%     sortedX = x(sortOrder);
% Fit a line through existing training points.
%     coefficients = polyfit(sortedY, sortedX, 1);
%     fittedY = 1:1024;
% Get fit and extrapolated values.
%     fittedX = polyval(coefficients, fittedY);
% %     hold on;
%     plot(fittedX, fittedY, 'c-', 'LineWidth', 2);
    % get the extrapoltaed line from ransac
%     a=max(ransac_data);
%     a =a(2);
%     total =[];
%     total(:,1)= fittedX;
%     total(:,2)= fittedY;
%     remain = total(a:end,:);
%     remain = round(remain);
%     final = remain(1:14:end,:);
%     % compare
%     C =ismember(dat,ransac_data,'rows');
%     %assign the comparison result 
%     out = [dataset num2cell(C)];
%     result_index =find(cell2mat(out(:,4))==1);
%     ransac_matrix = dataset(result_index,:);
%     imname =  ransac_matrix{1,3};
%     idx = find(ismember(totalimage, imname));
%     ransacimages =totalimage(1:idx-1);
%     ransacimages = flip(ransacimages);
%     [h,w] =size(ransacimages);
%     final(h:end,:) =[] ;
%     for i =1:numel(final(:,1))
%         ransac{i,1}= final(i,1);
%         ransac{i,2}= final(i,2);
%         ransac{i,3} =ransacimages{i};
%     end
%     % change x and y in matrix
%     r = ransac_matrix(:,2);
%     ransac_matrix(:,2)= ransac_matrix(:,1);
%     ransac_matrix(:,1)= r(:,1);
    % iterate through result 
    leftimage = totalimage(1:startimage);
    if numel(leftimage) ~= numel(ransacdata(:,1))
        break;
    end
    
    for m =1:numel(leftimage)
%   file = out(result_index(i),3);
        img = leftimage{m};
%       x1 = ransac{m,1};
        x1 = ransacdata(m,1);
        y1 = ransacdata(m,2);
        if x1 < 60
           x1 = 61;
        end
        if y1 >904
            y1=904;
        end
            
%         file= file{1,1};
%         image = strcat('C:\Users\PRASHANT\Documents\MATLAB\Needle_detection\5.10-\5181\',img);
        image = strcat(imgfolder,'\',img);
        image =imread(image);
%          if ransacdata(m,3) <= 25
%              crop1=imcrop(image,[x1-60,y1-100,120,240]);
%         elseif ransacdata(m,3) <= 29
%              crop1=imcrop(image,[x1-60,y1-150,120,240]);
%         elseif ransacdata(m,3) <= 33          
%              crop1=imcrop(image,[x1-60,y1-220,120,240]);
%          elseif ransacdata(m,3) <= 48          
%              crop1=imcrop(image,[x1-60,y1-250,120,240]);
%          elseif ransacdata(m,3) <= 55           
%              crop1=imcrop(image,[x1-60,y1-180,120,240]);
% %         else
% %             crop1=imcrop(image,[x1-30,y1-60,60,120]);
% %         end
%          else
          crop1=imcrop(image,[x1-20,y1-50,120,240]);
%          end
        fname2=fullfile(underretina_folder,img);
        imwrite(crop1,fname2);
    
    end
end