function h=make_guess(h)
%% Make guess once stuck

[a,b,c]=find(h.digit==0);
markup_size=zeros(h.n2,numel(c));
for i=1:numel(c)
    markup_size(:,i)=reshape(h.markup(a(i),b(i),:),h.n2,1);
end
[d,e]=sort(sum(~~markup_size,1));
% Choose first one with smallest possibility
g=h;
solved=0;
% numel(e)
for nn=1:numel(e)
    i=e(nn);
    choose_digit=g.markup(a(i),b(i),:);
    choose_digit=choose_digit(~~choose_digit);
    for nnn=1:d(nn)
        choosen_digit=choose_digit(nnn)
        g.digit(a(i),b(i))=choosen_digit;
        g.markup(a(i),b(i),:)=0;
        g=clean_markup(g);
        
        while ~solved
    
            [g,change]=solve1(g);
            if change==0 
                [g,change]=solve2(g);
                if change==0
                    g=make_guess(g);
                end        
            end
            display_grid(g)
            pause(1.5);

            con=check_conflict(g);
            if con==1
                g=h;
                continue;
            elseif check_solved(g)
                continue;
            else
                h=g;
                display_grid(g);
                pause(3);
                return
            end
        end
        display_grid(g);
        pause(3);
%         g.markup
    end
end
