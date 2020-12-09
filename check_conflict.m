function conflict=check_conflict(h)
    conflict=0;
    [tempa,tempb,tempc]=find(h.digit==0);
    markup_size=zeros(h.n2,numel(tempc));
    for i=1:numel(tempc)
        markup_size(:,i)=reshape(h.markup(tempa(i),tempb(i),:),h.n2,1);
    end
    [tempd,~]=sort(sum(~~markup_size,1));
     if numel(tempd)>0
        if tempd(1)==0 %% mismatch empty markup with undefined digit
            conflict=1;
            
        end
     else
        for kk=1:h.no_sub_grid
            i0=h.sub_grid_ind_begin(1,kk);
            i1=h.sub_grid_ind_end(1,kk);
            j0=h.sub_grid_ind_begin(2,kk);
            j1=h.sub_grid_ind_end(2,kk);
            sub_grid=reshape(h.markup(j0:j1,i0:i1,:),h.n2,h.n2);
%             [j_grid,i_grid]=ndgrid(j0:j1,i0:i1);
            a=sum(~~sub_grid,2);
            [id,~]=find(a==1); % find single elements
            if numel(id)==2
                if sub_grid(id(1),:) ==sub_grid(id(2),:)
                    conflict=1;
                    return
                end
            end
        end
     end
end           