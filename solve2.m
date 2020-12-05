function [h, ch_flag]=solve2(h,verb)
%% Second step solve (Look at pairs/triplets etc)
if nargin==1
    verb=0;
end
temp_digit=h.digit;
temp_markup=h.markup;

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
                if verb
                    disp(['yes found couplets in kk = ' num2str(kk) ' with k= ' num2str(k) ' list ' num2str(no_list)])
%                     disp('Removing from other elements');
                end
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

if sum(sum(h.digit ~=temp_digit))
    ch_flag=1;
elseif sum(sum(sum(h.markup~=temp_markup)))
    ch_flag=1;
else
    ch_flag=0;
end
end
