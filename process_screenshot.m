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
%% sub grids
h.no_sub_grid=n2*n;
sqre_list=((1:n)-1)*n+1;
sqre_begin_i_ind=sqre_list(reshape(repmat(1:n,n,1),1,n2));
sqre_begin_j_ind=repmat(sqre_list(1:n),1,n);
h.sub_grid_ind_begin=[ones(1,n2) 1:n2 sqre_begin_i_ind ;...
                   1:n2 ones(1,n2) sqre_begin_j_ind];
h.sub_grid_ind_end=[9*ones(1,n2) 1:n2 sqre_begin_i_ind+n-1 ; ...
                  1:n2  9*ones(1,n2) sqre_begin_j_ind+n-1 ];


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

function h=make_pencil(h)
for i=1:h.n2
    for j=1:h.n2
        if h.digit(j,i) ~= 0
            h.markup(j,i,:)=0;
            h.markup(j,i,h.digit(j,i))=h.digit(j,i);
        end
    end
end
end
%% Check row, column and box
function h=clean_markup(h)
for i=1:h.n2
    for j=1:h.n2
        row_list=h.digit(j,~~h.digit(j,:));
        if ~isempty(row_list)
            for k=row_list
                h.markup(j,i,k)=0;
            end
        end
        col_list=h.digit(~~h.digit(:,i),i);
        if ~isempty(col_list)
            for k=col_list
                h.markup(j,i,k)=0;
            end
        end
        sub_box_id_i=floor((i-1)/h.n)*h.n+1;
        sub_box_id_j=floor((j-1)/h.n)*h.n+1;
        ii=sub_box_id_i:sub_box_id_i+h.n-1;
        jj=sub_box_id_j:sub_box_id_j+h.n-1;
        sb_digit=h.digit(jj,ii);
        sub_box_list=sb_digit(~~sb_digit);
        if ~isempty(sub_box_list)
            for k=sub_box_list
                h.markup(j,i,k)=0;
            end
        end
    end
end
end
%% First step solve
function h=solve1(h)
for kk=1:h.no_sub_grid
% for kk=[3 6]
    i0=h.sub_grid_ind_begin(1,kk); 
    i1=h.sub_grid_ind_end(1,kk);
    j0=h.sub_grid_ind_begin(2,kk);
    j1=h.sub_grid_ind_end(2,kk);
    sub_grid=reshape(h.markup(j0:j1,i0:i1,:),h.n2,h.n2);
    [j_grid,i_grid]=ndgrid(j0:j1,i0:i1); 
    sum_grid=sum(~~sub_grid); % Sum possible markup values
    [~,id]=find(sum_grid==1); % find singleton elements
    if id
        disp(['yes,kk = ' num2str(kk) 'id = ' num2str(id)])
         for id0=1:numel(id) % for each single element
             [a,b,c]=find(sub_grid==id(id0));  % find other same elements to remove in other sub grid
             j=j_grid(a); i=i_grid(a); % absolute grid position
             h.digit(j,i)=b; %set digit in position
             h.markup(j,i,:)=0; %remove markup
             row_list=h.digit(j,~~h.digit(j,:)); %look at row
             if ~isempty(row_list) 
                for k=row_list
                    h.markup(j,:,k)=0; % remove markups of digit
                end
             end
             col_list=h.digit(~~h.digit(:,i),i); %look at col
             if ~isempty(col_list)
                 for k=col_list
                     h.markup(:,i,k)=0; % remove markups of digit
                 end
             end
             sub_box_id_i=floor((i-1)/h.n)*h.n+1;
             sub_box_id_j=floor((j-1)/h.n)*h.n+1;
             ii=sub_box_id_i:sub_box_id_i+h.n-1;
             jj=sub_box_id_j:sub_box_id_j+h.n-1;
             sb_digit=h.digit(jj,ii);
             sub_box_list=sb_digit(~~sb_digit); % look at small box
             if ~isempty(sub_box_list) 
                 for k=sub_box_list
                     h.markup(jj,ii,k)=0; %remove markup of digits
                 end
             end
         end
    end
 end
end
%% Second step solve (Look at pairs/triplets etc)
function h=solve2(h)
for kk=1:h.no_sub_grid
% for kk=19
    i0=h.sub_grid_ind_begin(1,kk);
    i1=h.sub_grid_ind_end(1,kk);
    j0=h.sub_grid_ind_begin(2,kk);
    j1=h.sub_grid_ind_end(2,kk);
    sub_grid=reshape(h.markup(j0:j1,i0:i1,:),h.n2,h.n2);
    [j_grid,i_grid]=ndgrid(j0:j1,i0:i1);
    a=sum(~~sub_grid,2);
    [id,b]=sort(a,'descend');
    id=id'; b=b';
    for k=1:numel(id)
        if id(k)==0
            continue
        else
            j=b(k);
            no_list=sub_grid(j,:);
            no_list=no_list(~~no_list);
            
%             not_in_list_count=0;
            count=0;
            couplet=[];
            for i=1:h.n2
                if sum(sub_grid(i,:)==0)==h.n2 % check if markup is empty
                    continue
                elseif sum(~~sub_grid(i,:))> numel(no_list)
                    continue
                else
                    if sum(~ismember(sub_grid(i,~~sub_grid(i,:)),no_list))>=1
                        continue
                    else
                        count=count+1;
                        couplet=[couplet i];
                    end
                end
            end
            if count>=id(k)
                disp(['yes found couplets in kk = ' num2str(kk) ' with k= ' num2str(k) ' list ' num2str(no_list)])
                disp(['Removing from other elements']);
%                 couplet
                not_couplet=~ismember(1:h.n2,couplet);
                j=j_grid(not_couplet); i=i_grid(not_couplet); % absolute grid position
%                 sub_box_id_i=floor((i-1)/n)*n+1;
%                 sub_box_id_j=floor((j-1)/n)*n+1;
%                 ii=sub_box_id_i:sub_box_id_i+n-1;
%                 jj=sub_box_id_j:sub_box_id_j+n-1;
                for zz=1:numel(j)
                    h.markup(j(zz),i(zz),no_list)=0; %remove markup of digits
                end
            end
        end
    end
end
end
%% Make guess once stuck
function h=make_guess(h)
[a,b,c]=find(h.digit==0);
markup_size=zeros(h.n2,numel(c));
for i=1:numel(c)
    markup_size(:,i)=reshape(h.markup(a(i),b(i),:),h.n2,1);
end
[~,e]=sort(sum(~~markup_size,1));
% Choose first one with smallest possibility
g=h;

i=e(1);
choose_digit=g.markup(a(i),b(i),:);
choose_digit=choose_digit(~~choose_digit);
choose_digit=choose_digit(1)
g.digit(a(i),b(i))=choose_digit;
g.markup(a(i),b(i),:)=0;
% g=solve1(g);
g=clean_markup(g);
g=solve1(g);
g=solve1(g);
display_grid(g);
pause(3);
[tempa,tempb,tempc]=find(g.digit==0);
markup_size=zeros(h.n2,numel(tempc));
for i=1:numel(tempc)
    markup_size(:,i)=reshape(g.markup(tempa(i),tempb(i),:),h.n2,1);
end
[tempd,tempe]=sort(sum(~~markup_size,1));
if numel(tempd)>0
if tempd(1)==0 %% mismatch empty markup with undefined digit
    g=h;

    i=e(1);
choose_digit=g.markup(a(i),b(i),:);
choose_digit=choose_digit(~~choose_digit);
choose_digit=choose_digit(2);
g.digit(a(i),b(i))=choose_digit;
g.markup(a(i),b(i),:)=0;
g=solve1(g);
g=clean_markup(g);
g=solve1(g);
g=solve1(g);
end
else
    h=g;
end
display_grid(g);
pause(3);
% g.markup

end
%% Display
function display_grid(h) 
figure(100)
set(gcf,'Position',[44    88   719   578])
axes
LW=3;LC='k';
n2=h.n2;
n=h.n;
x_i=0.5; x_f=n2+1-x_i;
y_i=0.5; y_f=n2+1-y_i;
xlim([x_i x_f]);
ylim([y_i y_f]);
hold all
% draw lines
for i=0:n2+1
aa=line([x_i x_f],[0.5 0.5]+i);
if mod(i,n)==0
    aa.LineWidth=LW;
    aa.Color=LC;
end
end
for j=0:n2+1
aa=line([0.5 0.5]+j ,[y_i y_f]);
if mod(j,n)==0
    aa.LineWidth=LW;
    aa.Color=LC;
end
end
% fill up grid
for i=1:n2
    for j=1:n2
        
        if h.digit(j,i) ~= 0
            text(i,n2-j+1,num2str(h.digit(j,i)),'FontSize',16,'horizontalalignment','center');
        else 
            penc_list=reshape(h.markup(j,i,:),1,n2);
            trim_list=num2str(penc_list(~~penc_list));
            trim_list=trim_list(~isspace(trim_list));
            text(i,n2-j+1-0.4,trim_list,'FontSize',8,'horizontalalignment','center','VerticalAlignment','bottom')
        end
    end
end
end