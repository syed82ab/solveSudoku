function sol=check_solved(h)
if sum(sum(sum(h.markup)))>0
    sol=0;
elseif sum(sum(sum(h.markup)))==0
    sol=1;
else
    sol=-1;
end