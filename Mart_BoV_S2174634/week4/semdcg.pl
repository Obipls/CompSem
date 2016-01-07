 
/* --------------------------------------------------
   Usage
-------------------------------------------------- */

% swipl -g "[semdcg],main,halt."
% swipl -g "[semdcg],main('in.txt','out.txt'),halt."

 
/* --------------------------------------------------
   Load other modules
-------------------------------------------------- */

:- use_module(library(porter_stem)).


/* -------------------------------------------------
   Main predicates
------------------------------------------------- */

main:- 
   parse1(user_input,user_output).

main(FileIn,FileOut):-
   open(FileIn,read,StreamIn),
   open(FileOut,write,StreamOut),
   parseN(StreamIn,StreamOut),
   close(StreamIn),
   close(StreamOut).


/* ------------------------------------------------
   Tokenizing and parsing (one sentence)
------------------------------------------------ */

parse1(StreamIn,StreamOut):-
   read_line_to_codes(StreamIn,Input),
   atom_codes(Atom,Input), 
   downcase_atom(Atom,Down),
   tokenize_atom(Down,Tokens),
   interpret(Tokens,StreamOut).


/* ------------------------------------------------
   Tokenizing and parsing (multiple sentences)
------------------------------------------------ */

parseN(StreamIn,StreamOut):-
   read_line_to_codes(StreamIn,Input),
   parseN(StreamIn,Input,StreamOut).

parseN(_,end_of_file,_):- !.

parseN(StreamIn,Input,StreamOut):-
   atom_codes(Atom,Input), 
   downcase_atom(Atom,Down),
   tokenize_atom(Down,Tokens),
   interpret(Tokens,StreamOut),
   parseN(StreamIn,StreamOut).


/* ------------------------------------------------
   Interpretation
------------------------------------------------ */

interpret(Tokens,Stream):-
   s([tree:T,sem:S],Tokens,[]), !, 
   reduce(S,R), numbervars(R,23,_),
   format(Stream,'-----~nparse for ~p~n~p~n~p~n',[Tokens,T,R]).

interpret(Tokens,Stream):-
   format(Stream,'-----~nno parse for ~p~n',[Tokens]).


/* ------------------------------------------------
   Beta-Reduction
------------------------------------------------ */

reduce(app(F,A),R):- nonvar(F), !, reduce(F,lam(A,R)).
reduce(and(F1,F2),and(R1,R2)):- !, reduce(F1,R1), reduce(F2,R2).
reduce(or(F1,F2),or(R1,R2)):- !, reduce(F1,R1), reduce(F2,R2).
reduce(imp(F1,F2),imp(R1,R2)):- !, reduce(F1,R1), reduce(F2,R2).
reduce(some(X,F),some(X,R)):- !,reduce(F,R).
reduce(all(X,F),all(X,R)):- !, reduce(F,R).
reduce(lam(X,F),lam(X,R)):- !, reduce(F,R).
reduce(not(F),not(R)):- !, reduce(F,R).
reduce(F,F).


/* ------------------------------------------------
   Grammar
------------------------------------------------ */

s([tree:s(NP,VP),sem:app(SemNP,SemVP)]) --> np([tree:NP,sem:SemNP]), vp([tree:VP,sem:SemVP]).
s([tree:s(NP,VP,P),sem:app(SemP,app(SemNP,SemVP))]) --> np([tree:NP,sem:SemNP]), vp([tree:VP,sem:SemVP]), punct([tree:P,sem:SemP]).
np([tree:np(Det,N),sem:app(SemDet,SemN)]) --> det([tree:Det,sem:SemDet]), n([tree:N,sem:SemN]).
vp([tree:vp(AV,VP),sem:app(SemAV,SemVP)]) --> av([tree:AV,sem:SemAV]), vp([tree:VP,sem:SemVP]).
vp([tree:vp(TV,NP),sem:app(SemTV,SemNP)]) --> tv([tree:TV,sem:SemTV]), np([tree:NP,sem:SemNP]).
vp([tree:vp(IV),sem:SemIV]) --> iv([tree:IV,sem:SemIV]).


/* ------------------------------------------------
   Lexicon: closed classes
------------------------------------------------ */

det([tree:det(a),sem:lam(P,lam(Q,some(X,and(app(P,X),app(Q,X)))))]) --> [a].
det([tree:det(every),sem:lam(P,lam(Q,all(X,imp(app(P,X),app(Q,X)))))]) --> [every].

av([tree:av(is),sem:lam(F,F)]) --> [is].
av([tree:av(is_not),sem:lam(F,lam(X,not(app(F,X))))]) --> [is,not].

punct([tree:punct('.'),sem:lam(F,F)]) --> ['.'].
punct([tree:punct('!'),sem:lam(F,F)]) --> ['!'].


/* ------------------------------------------------
   Lexicon: open classes
------------------------------------------------ */

n([tree:n(cat),sem:lam(X,n_cat_1(X))]) --> [cat].
n([tree:n(dog),sem:lam(X,n_dog_1(X))]) --> [dog].
n([tree:n(rock),sem:lam(X,n_rock_1(X))]) --> [rock].
tv([tree:tv(sitting),sem:lam(P,lam(X,app(P,lam(Y,s_supports(Y,X)))))]) --> [sitting,on].
iv([tree:iv(eating),sem:lam(X,some(Y,and(n_mouth_1(Y),and(s_part_of(Y,X),a_open_1(Y)))))]) --> [eating].
