function display_grid(h) 
% Display grid

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

if mod(i,n)==0
  aa=line([x_i x_f],[0.5 0.5]+i,'LineWidth',LW,'Color',LC);
  else
    aa=line([x_i x_f],[0.5 0.5]+i);
end
end
for j=0:n2+1
if mod(j,n)==0
    aa=line([0.5 0.5]+j ,[y_i y_f],'LineWidth',LW,'Color',LC);
  else
    aa=line([0.5 0.5]+j ,[y_i y_f]);
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