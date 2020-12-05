function h=make_guess(h)
%% Make guess once stuck

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
