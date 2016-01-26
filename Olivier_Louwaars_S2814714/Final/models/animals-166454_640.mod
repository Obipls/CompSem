model([d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12],
      [f(1,n_boy_1,[d1]),
       f(1,n_short_pants_1,[d2]),
       f(1,n_shirt_1,[d3]),
       f(1,a_blue_1,[d2]),
       f(1,a_striped_1,[d3]),
       f(1,n_pigeon_1,[d3,d4,d5,d6,d7,d8,d9,d10,d11]),
       f(1,n_street_1,[d12]),
       f(2,s_touches,[(d1,d2),(d2,d1),(d1,d3),(d3,d1),(d2,d3),(d3,d2),(d1,d12),(d12,d1),(d3,d12),(d12,d3),(d4,d12),(d12,d4),
	   (d5,d12),(d12,d5),(d6,d12),(d12,d6),(d7,d12),(d12,d7),(d8,d12),(d12,d8),(d9,d12),(d12,d9)]),
       f(2,s_supports,[(d1,d2),(d1,d3),(d12,d1),(d12,d3),(d12,d4),(d12,d5),(d12,d6),(d12,d7),(d12,d8),(d12,d9)]),
       f(2,s_near,[(d2,d1),(d3,d1),(d7,d1),(d6,d1),(d5,d1),(d8,d1),(d11,d1),(d1,d2),(d3,d2),(d1,d3),(d2,d3),(d5,d6),
	   (d6,d5)])
	   ]).
      
