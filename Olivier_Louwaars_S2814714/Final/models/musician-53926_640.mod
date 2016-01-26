model([d1,d2,d3,n1,d4,d5,d6,d7,d8],
      [f(1,n_grass_1,[d1]),
       f(1,n_hurdygurdy_1,[d2]),
       f(1,n_man_1,[d3]),
       f(1,n_beard_1,[n1]),
	   f(1,n_stool_1,[d4]),
	   f(1,n_fence_1,[d5,d6]),
	   f(1,n_foot_1,[d7,d8]),
	   f(2,s_touches,[(d3,d2),(d2,d3),(d4,d3),(d3,d4),(d4,d1),(d1,d4),(d1,d7),(d7,d1),(d1,d8),(d8,d1)]),
	   f(2,s_supports,[(d3,d2),(d4,d3),(d1,d4),(d1,d7),(d1,d8)]),
	   f(2,s_part_of,[(n1,d3),(d7,d3),(d8,d3)])]).
