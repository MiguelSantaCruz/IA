%Invariantes

:-op(900,xfy,'::').

%Impedir a introdução de um estafeta com um id já existente
+estafeta(Id, _, _) :: (
	solucoes(_,estafeta(Id, _,_),L),
	comprimento(L,0)
).

%Impedir a introdução de uma entrega com um id já existente
+entrega(Id, _, _, _, _) :: (
	solucoes(_,entrega(Id, _, _, _,_),L),
	comprimento(L,0)
).

%O identificador do estafeta deverá existir
+entrega(_, IdEstafeta, _, _, _) :: (
	solucoes(_,estafeta(IdEstafeta,_,_),L),
	comprimento(L,N),
	N >= 1
).


%Impedir a introdução de uma encomenda com um id já existente
+encomenda(ID,_,_,_,_,_,_,_,_) :: (
	solucoes(_,encomenda(ID,_,_,_,_,_,_,_,_),L),
	comprimento(L,0)
).

%O identificador da rua deverá existir
+encomenda(_,_,_,_,_,IdRua,_,_,_) :: (
	solucoes(_,rua(IdRua,_,_),L),
	comprimento(L,N),
	N >= 1
).

%O identificador do cliente deverá existir
+encomenda(_,_,_,IdCliente,_,_,_,_,_) :: (
	solucoes(_,cliente(IdCliente,_,_,_),L),
	comprimento(L,N),
	N >= 1
).

%O identificador do transporte deverá existir
+encomenda(_,_,_,_,_,_,IdTrans,_,_) :: (
	solucoes(_,transporte(IdTrans,_,_,_,_),L),
	comprimento(L,N),
	N >= 1
).

%Impedir a introdução de uma rua com um id já existente
+rua(Id, _, _):: (
	solucoes(_,rua(Id, _,_),L),
	comprimento(L,0)
).

%Impedir a introdução de uma estrada com um id já existente
+estrada(Id,_,_,_):: (
	solucoes(_,estrada(Id,_,_,_),L),
	comprimento(L,0)
).

%As duas ruas deverão existir previamente
+estrada(_,IdRua1,IdRua2,_):: (
	solucoes(_,rua(IdRua1, _,_),L1),
	comprimento(L1,N1),
	N1 >= 1,
	solucoes(_,rua(IdRua2, _,_),L2),
	comprimento(L2,N2),
	N2 >= 1
).


%Impedir a introdução de um transporte com um id já existente
+transporte(IdTrans,_,_,_,_):: (
	solucoes(_,transporte(IdTrans,_,_,_,_),L),
	comprimento(L,0)
).

%predicado soluções
solucoes(_,L,R) :- findall(_,L,R).

%predicado comprimento
comprimento([],0).
comprimento([_|LS],N2) :- comprimento(LS,N1), N2 is N1+1. 

%Adicionar á base de conhecimento
evolucao(Term) :- findall(I, +Term :: I, L),
		  adiciona(Term),
		  test(L),
		  write('\033[0;32mTermo adicionado\033[0m'),nl,!.
evolucao(_) :- write('\033[0;31mTermo não adicionado\033[0m'),nl,!,fail.

%Remover da base de conhecimento
regressao(Term) :- findall(I, -Term :: I,L),
		   remove(Term),
		   test(L),
		   write('\033[0;32mTermo removido\033[0m'),nl,!.
regressao(_) :- write('\033[0;31mTermo não removido\033[0m'),nl,!,fail. 
	 
%Predicado auxiliar de inserção
adiciona(Term) :- assertz(Term).
adiciona(Term) :- retract(Term),!,fail.

%Predicado auxiliar de remoção
remove(Term) :- retract(Term).
remove(Term) :- assertz(Term),!,fail.

%Predicado que verifica um determinado termo
test([]).
test([R|Rs]):- R,test(Rs).
