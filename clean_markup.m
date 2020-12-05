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
