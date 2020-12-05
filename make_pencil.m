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
