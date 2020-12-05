%% First step solve
function [h,ch_flag]=solve1(h,verb)
if nargin==1
    verb=0;
end
temp_digit=h.digit;
temp_markup=h.markup;
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
        if verb
            disp(['yes,kk = ' num2str(kk) 'id = ' num2str(id)])
        end
         for id0=1:numel(id) % for each single element
             [a,b,~]=find(sub_grid==id(id0));  % find other same elements to remove in other sub grid
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
% h.digit ~=temp_digit
if sum(sum(h.digit ~=temp_digit))
    ch_flag=1;
elseif sum(sum(sum(h.markup~=temp_markup)))
    ch_flag=1;
else
    ch_flag=0;
end
end

