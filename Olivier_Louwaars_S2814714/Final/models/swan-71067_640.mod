model([d1,d2,d3,d4,w1],
      [f(1,n_mute_swan_1,[d1]),
	 f(1,n_duck_1,[d2,d3,d4]),
	 f(1,n_lake_1,[w1]),
	 f(1,a_white_2,[d1,d2,d3,d4]),
	 f(1,a_blue_1,[w1]),
	 f(2,s_supports,[(w1,d1),(w1,d2),(w1,d3),(w1,d4)]),
	 f(2,s_touches,[(d1,w1),(d2,w1),(d3,w1),(d4,w1),(w1,d1),(w1,d2),(w1,d3),(w1,d4)]),
	 f(2,s_near,[(d2,d3),(d3,d2),(d2,d4),(d4,d2),(d4,d3),(d3,d4)])]).
