
%% start
% / showing the image
clear all
close all
clc
p0=imread('test 1.jpg');
figure,imshow(p0);
%% / changing to gray scale
p =rgb2gray(p0);
figure,imshow(p);
p=im2double(p);
figure,imshow(p)
%%  / filtering
f=fspecial('gaussian');
pf=imfilter(p,f,'replicate');
figure,imshow(pf)
%% / taking average

Pm=mean2(pf);   % Average elements matrix

Pv=((std2(pf))^2); % variance M-by-N matris ' square' E standard situation  - pf  replicate of image
T=Pm+Pv;
%%
% / threshold definition
[m, n]=size(pf);
for j=1:n
for i=1:m
if pf(i,j)>T;
pf(i,j)=1;
else
pf(i,j)=0;
end
end
end
%% layering
ps=edge(pf,'sobel');
figure,imshow(ps)
%% shade of image
pd=imdilate(ps,strel('diamond',1)); % shading
pe=imerode(pd,strel('diamond',1)); % shading
%% holes finding
pl=imfill(pe,'holes');  %hole finfing
figure,imshow(pl);
[m, n]=size(pl);
%% tagging
pll=bwlabel(pl);
figure,imshow(pll);
stat=regionprops(pll,'Area','Extent','BoundingBox','Image','Orientation','Centroid');
index = (find([stat.Area] == max([stat.Area]))); % finding the bigest area in the image to detect the car plate
ppout=stat(index).Image;
figure,imshow(ppout);
%% extracting feature from binary scale

x1 = floor(stat(index).BoundingBox(1)); %index of column of the first pixel (B = floor(A) rounds the elements of A to the nearest integers less than or equal to A) 
x2 = ceil(stat(index).BoundingBox(3));  %object width in horizontal direction (B = ceil(A) rounds the elements of A to the nearest integers greater than or equal to A)
y1 = ceil(stat(index).BoundingBox(2));  %index of row of the first pixel (B = ceil(A) rounds the elements of A to the nearest integers greater than or equal to A)
y2 = ceil(stat(index).BoundingBox(4));  %object width in vertical direction(B = ceil(A) rounds the elements of A to the nearest integers greater than or equal to A)
bx=[y1 x1 y2 x2];  
ppc=imcrop(p0(:,:,:),[x1,y1,x2,y2]);
figure,imshow(ppc)
%% separating the care plate image from the rest of image
ppg=imcrop(p(:,:),[x1,y1,x2,y2]);
figure,imshow(ppg)
%% resolution enhancement
ppcg=rgb2gray(ppc);
ppcg=imadjust(ppcg, stretchlim(ppcg), [0 1]); % specify lower and upper limits that can be used for contrast stretching image(J = imadjust(I,[low_in; high_in],[low_out; high_out]))
ppg=im2double(ppcg);
pb=im2bw(ppg);%im2bw(I, level) tabdil be binery
image
figure,imshow(pb)
%% reducing the angles of images
if abs(stat(index).Orientation) >=1; %The orientation is the angle between the horizontal line and the major axis of ellipse=angle
ppouto=imrotate(ppout,-stat(index).Orientation); %B = imrotate(A,angle) rotates image A by angle degrees in a counterclockwise direction around its center point. To rotate the image clockwise, specify a negative value for angle.
pbo=imrotate(pb,-stat(index).Orientation);
angle = stat(index).Orientation;
else  
pbo=pb;


end
figure,imshow(pbo),title('*BEDOONE ZAVIYE*') % angle removing
%%
pbod=imdilate(pbo,strel('line',1,0));
pbodl=imfill(pbod,'holes');
px = xor(pbodl , pbod);
pz= imresize(px, [44 250]); % 4*(57*11)=(4 times of iranian car plate size)
%% car plate tagging
stat1 = regionprops(logical(pz,4),'Area','Image');
index1 = (find([stat1.Area] == max([stat1.Area])));
maxarea =[stat1(index1).Area]; % elimination of useless part of image
pzc=bwareaopen(pz,maxarea-30); %maxarea(1,1) meghdare structur ra adres dehi mikonad,va migoyad object haye ka mte z an ra hazf konad
                                %aplaying the address on structure
%% histogram plak
%v=sum(pzc);
%plot(v); 
%% characters extraction
stat1 = regionprops(logical(pz,4),'Area','Image');
index1 = (find([stat1.Area] == max([stat1.Area])));
maxarea =[stat1(index1).Area];
pzc=bwareaopen(pz,maxarea-200);
%%
% nf1=temp.*cx{1,i};
% nf2=sum(sum(nf1));
% nf(j)=nf2/(sum(sum(temp)));
% mx=max(nf(j));
%%
stat2=regionprops(pzc,'Area','BoundingBox','Image','Orientation','Centroid');
cx=cell(1,8);
for i=1:8
x=stat2(i).Image;
rx=imresize(x, [60 30]);
%figure,imshow(rx)

cx{1,i}=rx;
fx=mat2gray(cx{1,1});
imshow(cx{1,2})
imwrite(rx,['C:\Users\omid\Documents\MATLAB\' num2str(i) '.jpg']);% writing the address of charachters 
end
%% characters reading
for i=1:1
for j=1:8
temp=imread(['C:\Users\omid\Documents\MATLAB\' num2str(j) '.jpg']);
temp=im2bw(temp);
nf1=temp.*cx{1,i};
nf2=sum(sum(nf1));
nf(j)=nf2/(sum(sum(temp)));
mx=max(nf(j));
if nf(1,1)== mx
disp(1);
else
if nf(1,2)== mx
disp(5);
else
if nf(1,3)== mx
disp('j');
else
if nf(1,4)== mx
disp(6);
else
if nf(1,5)== mx
disp(3);
else
if nf(1,6)== mx
disp(1);
else
if nf(1,7)== mx
disp(7);
else
if nf(1,8)== mx
disp(2);
end
end
end
end
end
end
end
end 
end
end
%%  end
