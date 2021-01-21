load('hardpuzzle.mat')


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