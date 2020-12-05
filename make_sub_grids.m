%% sub grids
function h=make_sub_grids(h)
n2=h.n2;n=h.n;
h.no_sub_grid=n2*n;
sqre_list=((1:n)-1)*n+1;
sqre_begin_i_ind=sqre_list(reshape(repmat(1:n,n,1),1,n2));
sqre_begin_j_ind=repmat(sqre_list(1:n),1,n);
h.sub_grid_ind_begin=[ones(1,n2) 1:n2 sqre_begin_i_ind ;...
                   1:n2 ones(1,n2) sqre_begin_j_ind];
h.sub_grid_ind_end=[9*ones(1,n2) 1:n2 sqre_begin_i_ind+n-1 ; ...
                  1:n2  9*ones(1,n2) sqre_begin_j_ind+n-1 ];
