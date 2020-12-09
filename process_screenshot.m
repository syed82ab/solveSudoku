clearvars


%% declare sizes and grid
n=3;
n2=n^2;
% n=sqrt(n2);
box_size=109-2;
line_thick=6+2;
line_thin=4+2;
nref_pos=[372 844 box_size*n+(n-1)*line_thin box_size*n+(n-1)*line_thin];
pos=[31 503];
rect=[box_size*n2+(n-1)*(n*line_thin+line_thick)  box_size*n2+(n-1)*(n*line_thin+line_thick)];


% Load reference of numbers and set into array
number_ref=imread('grid1.png');
numbers_im=imcrop(rgb2gray(number_ref),nref_pos);
figure(3)
imshow(numbers_im);
numpos=[7 6 1; 3 5 8 ; 9 4 2];
dig_ref=uint8(zeros(box_size,box_size,9));
dig_val=uint8(zeros(n2,1));
image_ref=uint8(zeros(box_size,box_size));
for i=1:3
    for j=1:3
        k=(i-1)*3+1 +j-1;
    dig_val(k)=numpos(k);
    ind_0=(i-1)*box_size+1+floor((i-1))*line_thin;
    ind_1=(j-1)*box_size+1+floor((j-1))*line_thin;
    image_ref=(imcrop(numbers_im,[ind_0 ind_1 box_size-1 box_size-1]));
    dig_ref(:,:,k)=image_ref;
    figure(20)
    subplot(3,3,k)
    imshow(image_ref);
    title(['val = ' num2str(dig_val(k)) ', k val = ' num2str(k) ]);
    end
end

%% Load puzzle and find each box
screenshot=imread('grid.png');
figure(1);
imshow(screenshot)
cropped=imcrop(rgb2gray(screenshot),[pos rect]);
figure(1)
imshow(cropped)
box=uint8(zeros(box_size,box_size,n2,n2));
figure(2)

for i=1:n2
    for j=1:n2
        ind_0=(i-1)*box_size+1+floor((i-1))*line_thin+floor((i-1)/3)*(line_thick-line_thin);
        ind_1=(j-1)*box_size+1+floor((j-1))*line_thin+floor((j-1)/3)*(line_thick-line_thin);
        box(:,:,i,j)=(imcrop(cropped,[ind_0 ind_1 box_size-1 box_size-1]));
%         nn=(j-1)*n2 + (i-1) +1;
%         subplot(n2,n2,nn)
%         imshow(box(:,:,i,j));
    end
end
        
 
%% read values of existing numbers
% figure
% imshow(box(:,:,3,1))
corr_lim=0.75;
% subtract_lim=600;
dig_cor=zeros(n2,n2);
h.digit=uint8(zeros(n2,n2));
h.n=n;h.n2=n2;
for i=1:n2
    for j=1:n2
        for k=1:n2
            val=max(max(normxcorr2(box(:,:,i,j),dig_ref(:,:,k))));
%           val= sum(sum(box(:,:,i,j)-dig_ref(:,:,k)));
            if val > corr_lim
%             if val < subtract_lim
                if val>dig_cor(j,i)
                h.digit(j,i)=dig_val(k);
                dig_cor(j,i)=val;
                end
            end
        end
    end
end


%% Solve puzzle
h=make_sub_grids(h);

%% make pencil marks
% fill up everything
h.pencil=linspace(1,n2,n2); 
h.markup=repmat(reshape(h.pencil,1,1,n2),n2,n2,1);

% Remove known digits
h=make_pencil(h);
display_grid(h)
pause(3)
h=clean_markup(h);
display_grid(h);
pause(3)
h=solve1(h);
display_grid(h);
pause(3)
h=solve2(h);
display_grid(h);
pause(3)
h=solve1(h);
display_grid(h);
pause(3)
h=solve1(h);
display_grid(h);
pause(3)
%%
h=make_guess(h);
% display_grid(h);
pause(3);

