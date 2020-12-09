% Open up a webpage
% puzzleno=4345638452;
puzzleno=49;
url = ['https://www.websudoku.com/?level=4&set_id=',num2str(puzzleno)]; % Evil
[~, webHandle] = web(url,'-new','-notoolbar');
% Wait until the web page is loaded. There may be a way to do this
% programatically, I haven't looked into this
pause(7);
% Get the web page location in the screen space
location = webHandle.getLocationOnScreen();
% Create and set the java rectangle object dimensions
image_loc.x=0.4;image_loc.y=0.3;
rect = java.awt.Rectangle();
rect.width = webHandle.getWidth();
rect.height = webHandle.getHeight();
rect.x = location.x+rect.width*image_loc.x;
rect.y = location.y+rect.height*image_loc.y;
rect.width=rect.width*(1-image_loc.x);
rect.height=rect.height*(1-image_loc.y);
% Get a screen capture of the window space using a java robot
robot = java.awt.Robot();
capture = robot.createScreenCapture(rect);
% Data time!
rawData = reshape(capture.getRaster().getDataBuffer().getData(), rect.width, rect.height); % Returns an int32 where RGB is store in 8 bytes of each int
rgb = zeros(rect.height, rect.width, 3); % Buffer for RGB triplets so Matlab can plot it. Note how the dimensions are seemingly reversed
rgb(:, :, 1) = bitshift(bitand(rawData', hex2dec('ff0000')), -16); % Red
rgb(:, :, 2) = bitshift(bitand(rawData', hex2dec('ff00')), -8); % Green
rgb(:, :, 3) = bitand(rawData', hex2dec('ff')); % Blue
% Scale from 0-255 to 0-1, because Matlab is just weird
rgb = rgb / 255;
% Plot the image
figure;
image(rgb);
%%
bw=rgb2gray(rgb);
BW = edge(bw,'canny');

%%
[B,L,N,A]=bwboundaries(BW,'noholes');

figure
imshow(bw)
hold on
%%
max_len_b=0;
for k = 1:length(B)
   boundary = B{k};
   len_b=length(boundary);
   if len_b>max_len_b
       max_len_b=len_b;
       max_k=k;
   end
end  
boundary = B{max_k};
plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 0.1)
%%
puzzle.x=uint16( min(boundary(:,1)));
puzzle.y=uint16( min(boundary(:,2)));
puzzle.width=uint16( max(boundary(:,1))-puzzle.x);
puzzle.height=uint16( max(boundary(:,2))-puzzle.y);
puzzle.img=imresize(rgb(puzzle.x:puzzle.x+puzzle.width,puzzle.y:puzzle.height+puzzle.y,:),3);
figure
imshow(puzzle.img)
s=regionprops(imbinarize(rgb2gray(puzzle.img),0.8),'BoundingBox');
bboxes = vertcat(s(:).BoundingBox);
% Sort boxes by image height
[~,ord] = sort(bboxes(:,1));
bboxes = bboxes(ord,:);
bbox_good=zeros(81,4);
ii=1;
for i=1:size(bboxes,1)
        if bboxes(i,3)> 70 && bboxes(i,3) < 100
            bbox_good(ii,:)=bboxes(i,:);
            ii=ii+1;
        end
       rectangle('Position',bboxes(i,:),'EdgeColor','r')
end
hold on
for i = 1: length(bbox_good)
       rectangle('Position',bbox_good(i,:),'EdgeColor','r')
       text(bbox_good(i,1)+2,bbox_good(i,2)+2,num2str(i),'FontSize',9,'Color','r','horizontalalignment','center','VerticalAlignment','bottom')
end
puzzle.bbox=bbox_good;
%%
out=ocr(imbinarize(rgb2gray(puzzle.img),0.44),bbox_good,'CharacterSet','123456789','TextLayout','Block');

figure
imshow(puzzle.img);
hold on
ii=1;
for i=1:numel(out)
    if isempty(out(i).Text)
        cl = 'g';
    else
        cl = 'r';
        text(out(i).WordBoundingBoxes(1),out(i).WordBoundingBoxes(2),out(i).Text,'FontSize',8,'horizontalalignment','center','VerticalAlignment','bottom')
        text(out(i).WordBoundingBoxes(1)+2,out(i).WordBoundingBoxes(2)+2,num2str(i),'FontSize',9,'Color','r','horizontalalignment','center','VerticalAlignment','bottom')
        rectangle('Position',out(i).WordBoundingBoxes,'EdgeColor',cl)
        list(ii)=i;
        ii=ii+1;
    end
    
end
%%
digits=zeros(9,9);
list2=vertcat(out(list).WordBoundingBoxes);
txtlist=str2num(vertcat(out(list).Text));
box_size=94;
for i=1:length(list2)
digits(floor(list2(i,2)/box_size)+1,floor(list2(i,1)/box_size)+1)=txtlist(i);
end
size(digits);
% digits
%%

h.digit=digits;
h.n=3;
h.n2=9;
h.pencil=linspace(1,h.n2,h.n2); 
h.markup=repmat(reshape(h.pencil,1,1,h.n2),h.n2,h.n2,1);

h=make_pencil(h);
h=clean_markup(h);
display_grid(h)
solved=0;
change=0;
h=make_sub_grids(h);
%%
while ~solved
    
    [h,change]=solve1(h);
    if change==0 
        [h,change]=solve2(h);
        if change==0 
             h=make_guess(h);
        end        
    end
    display_grid(h)
    pause(1.5);
    solved=check_solved(h);
end
display_grid(h)