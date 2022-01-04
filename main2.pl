%#!/usr/bin/env swipl
%:- initialization(main, main).


%carregar a base de conhecimento atual
:- consult('baseConhecimentoGrafo.pl').

%Loop principal que implementa o menu de interação com a aplicação
%Nota:\u001b[32m é o código de cor para verde, \u001b[34m é o código de cor para vermelho e \u001b[0m é o código de reset de cor
%As cores só funcionam em terminais unix
main :- write('\033[H\033[2J'),
	repeat,
	write('\u001b[32mGreen distribution\u001b[0m 🌲 --------------------------------------------------------------------------'),nl,
	write('\u001b[34m[1]\u001b[0m Encontrar caminho até ao nodo (Heurística A*)'),nl,
	write('\u001b[34m[2]\u001b[0m Encontrar caminho até ao nodo (Greddy search)'),nl,
	write('\u001b[34m[3]\u001b[0m Encontrar caminho até ao nodo (DFS)'),nl,
	write('\u001b[34m[4]\u001b[0m Encontrar caminho até ao nodo (BFS)'),nl,
	write('\u001b[34m[5]\u001b[0m Encontrar caminho até ao nodo (DFS com profundidade limitada)'),nl,
	write('\u001b[34m[6]\u001b[0m Sair'),nl,
	nl,
	write('Insira escolha: '),nl,
	read(Escolha),
	validaEscolha(Escolha),
	executa(Escolha),
  	nl,nl,fail.
 
%Função que valida as escolhas feitas( se estão entre 1 e 17)  
validaEscolha(X) :- X =< 0,write('\u001b[31mEscolha inválida\u001b[0m'),nl,!,fail.
validaEscolha(X) :- X > 7,write('\u001b[31mEscolha inválida\u001b[0m'),nl,!,fail.
validaEscolha(_).

%Função que chama as funções que implementam as funcionalidades
executa(X) :- X =:= 1, nl,write('Insira o ID da rua atual'),nl,
						read(Nodo),nl,
						resolve_aestrela(Nodo,Cam/C),
						nomeRua(Cam,Ruas),
						printList(Ruas),nl,write('Custo: '),write(C),nl,!.
executa(X) :- X =:= 2, nl, write('Insira ID Estafeta : '),nl,
                            read(IDestafeta),nl,
			     getRuaPorEstafeta(IDestafeta,Idrua/PT/PZ/_),
			     transPossiveis(Idrua/PT/PZ/_, Trans,C,TempFinal),
			     inverso(C,Cinv),
			     nomeTr([Trans],T),
			     nomeRua(Cinv,CN),
			     write('Peso da encomenda: '), write(PT),nl,
			     write('Prazo de entrega(horas): '), write(PZ),nl,
			     write('Nome do transporte: '), printList(T),
			     write('Tempo da entrega:'),write(TempFinal),nl,
			     write('Percurso: '),nl,
			     printList(CN),nl,!.
executa(X) :- X =:= 3, nl,write('Insira o ID da rua atual'),nl,
						read(Nodo),nl,
						dfs(Nodo,L,C),
						nomeRua(L,Ruas),
						printList(Ruas),nl,write('Custo: '),write(C),nl,!.
executa(X) :- X =:= 4, nl,write('Insira o ID da rua atual'),nl,
							read(NodoI),nl,
							write('Insira o ID da rua que pretende ir'),nl,
							read(NodoF),nl,
							breadth_first(NodoI, NodoF, Cam, D),
							nomeRua(Cam,Ruas),
							printList(Ruas),nl,write('Distância: '),write(D),nl,!.
executa(X) :- X =:= 5, nl,write('Não implementada'),nl,!.
executa(X) :- X =:= 6, halt.


%Funções auxiliares gerais ------------------------------------------

%Predicado not
not(X) :- X, !, fail.
not(_X).

%Adicionar um elemento a uma lista
adicionarElemLista(X,[],[X]).
adicionarElemLista(X,L,[X|L]).

%Fazer o print de uma lista
printList([]) :- write('Sem Elementos'),nl.
printList([X]) :- write(X),nl.
printList([X|XS]) :- write(X),nl,printList(XS).
printList(_) :- write('Não é lista'),nl.


%----------------------------------------------------------------------------------------------------------------------------------------------------------------

% profundidade DFS


dfs(Nodo,[Nodo|Caminho],C) :- profundidade(Nodo,[Nodo],Caminho,C).


profundidade(T,_,[],0) :- goal(T).

profundidade(Nodo,Historico,[ProxNodo|Caminho],Distancia) :- 
    adjacente(Nodo,ProxNodo,Distancia1),
    not(member(ProxNodo,Historico)),
    profundidade(ProxNodo,[ProxNodo|Historico],Caminho,Distancia2), Distancia is Distancia1+Distancia2.

adjacente(Nodo, ProxNodo,Distancia) :- estrada(_,Nodo,ProxNodo,Distancia).
adjacente(Nodo, ProxNodo,Distancia) :- estrada(_,ProxNodo,Nodo,Distancia).

% BFS


breadth_first(Orig, Dest, Cam, D):- bfs(Dest,[[Orig]],Cam),
									  			bfsDist(Cam, D).


bfsDist([X,Y], D) :- adjacente(X,Y,D).
bfsDist([X,Y|T], D) :- adjacente(X,Y,D1),
								bfsDist([Y|T], D2),
								D is D1+D2.		 


bfs(EstadoF,[[EstadoF|T]|_],Solucao)  :- reverse([EstadoF|T],Solucao).
bfs(EstadoF,[EstadoA|Outros],Solucao) :- 
    EstadoA = [F|_],
    findall([X|EstadoA],
            (EstadoF\==F,
            adjacente(X,F,Distancia),
            not(member(X,EstadoA))),
            Novos),
    append(Outros,Novos,Todos),
    bfs(EstadoF,Todos,Solucao).

%------

resolve_aestrela(Nodo, Caminho/Custo) :-
	estima(Nodo, Estima),
	aestrela([[Nodo]/0/Estima], InvCaminho/Custo/_),
	inverso(InvCaminho, Caminho).

aestrela(Caminhos, Caminho) :-
	obtem_melhor(Caminhos, Caminho),
	Caminho = [Nodo|_]/_/_,
	goal(Nodo).

aestrela(Caminhos, SolucaoCaminho) :-
	obtem_melhor(Caminhos, MelhorCaminho),
	seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
	expande_aestrela(MelhorCaminho, ExpCaminhos),
	append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
    aestrela(NovoCaminhos, SolucaoCaminho).	

obtem_melhor([Caminho], Caminho) :- !.
obtem_melhor([Caminho1/Custo1/Est1,_/Custo2/Est2|Caminhos], MelhorCaminho) :-
	Custo1 + Est1 =< Custo2 + Est2, !,
	obtem_melhor([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho). 
obtem_melhor([_|Caminhos], MelhorCaminho) :- 
	           obtem_melhor(Caminhos, MelhorCaminho).



expande_aestrela(Caminho, ExpCaminhos) :-
	findall(NovoCaminho, adjacente2(Caminho,NovoCaminho), ExpCaminhos).

%Gulosa----------------------------------------------------------------------------------

getRuaPorEstafeta(IdEst,T):- findall(L,estafeta(IdEst,_,L),[Lenc|_]),
					findall(Idrua/Peso/Prazo/Idenc,(member(Idenc,Lenc),encomenda(Idenc, Peso, _, _, Prazo,Idrua,_,emDistribuicao,_)),[T|_]).



getPesoTotal([],0).
getPesoTotal([_/Peso/_],Peso).
getPesoTotal([_/P/_,_/P2/_|T], Peso) :- P3 is P+P2,
                                 getPesoTotal(T,Ps),
                                 Peso is P3 + Ps.


transPossiveis(Idrua/PesoT/Prazo/_, Trans,C,TF) :-resolve_gulosa(Idrua,C/Dist),
        ((PesoT=<100,PesoT>20) -> Trans is 3;
         (PesoT=<20,PesoT>5)   -> escolheM_C(Dist,Trans,Prazo,PesoT,TF);%mota ou carro
         (PesoT>0,PesoT=<5)    -> escolheMaisEco(Dist,Trans,Prazo,PesoT,TF)).%bicicleta, mota ou carro


nomeRua([],[]).
nomeRua([H|T],L):-findall(Nome,rua(H,Nome),[S|_]),
                  nomeRua(T,Z),
               L = [S|Z].

nomeTr([],[]).
nomeTr([H|T],L):-findall(Nome,transporte(H,Nome,_,_,_),[S|_]),
                  nomeTr(T,Z),
               L = [S|Z].							
								
escolheM_C(Dist,T,Prazo,Peso,TF) :- TempoM is Dist/ (35 - (0.5 * Peso)),TempoC is Dist/ (25 - (0.1 * Peso)),
			((TempoM =< Prazo) -> T is 2,TF is TempoM;
			T is 3,TF is TempoC).							
								
escolheMaisEco(Dist,T,Prazo,Peso,TF) :- TempoB is (Dist)/ (10 - (0.7 * Peso)), TempoM is Dist/ (35 - (0.5 * Peso)),TempoC is Dist/ (25 - (0.1 * Peso)),
				((TempoB =< Prazo) -> T is 1,TF is TempoB;
				(TempoM =< Prazo) -> T is 2,TF is TempoM;
				T is 3,TF is TempoC).							

resolve_gulosa(Nodo,CaminhoDistancia/CustoDist):-
	estima(Nodo, Estima),
	agulosa_distancia_g([[Nodo]/0/Estima], InvCaminho/CustoDist/_),
	inverso(InvCaminho, CaminhoDistancia).

agulosa_distancia_g(Caminhos, Caminho) :-
	obtem_melhor_distancia_g(Caminhos, Caminho),
	Caminho = [Nodo|_]/_/_,
	goal(Nodo).

agulosa_distancia_g(Caminhos, SolucaoCaminho) :-
	obtem_melhor_distancia_g(Caminhos, MelhorCaminho),
	seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
	expande_agulosa_distancia_g(MelhorCaminho, ExpCaminhos),
	append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
        agulosa_distancia_g(NovoCaminhos, SolucaoCaminho).	

obtem_melhor_distancia_g([Caminho], Caminho) :- !.
obtem_melhor_distancia_g([Caminho1/Custo1/Est1,_/_/Est2|Caminhos], MelhorCaminho) :-
	Est1 =< Est2, !,
	obtem_melhor_distancia_g([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho). 
obtem_melhor_distancia_g([_|Caminhos], MelhorCaminho) :- 
	obtem_melhor_distancia_g(Caminhos, MelhorCaminho).
	

expande_agulosa_distancia_g(Caminho, ExpCaminhos) :-
	findall(NovoCaminho, adjacente2(Caminho,NovoCaminho), ExpCaminhos).



adjacente2([Nodo|Caminho]/Custo/_, [ProxNodo,Nodo|Caminho]/NovoCusto/Est) :-
	estrada(_,Nodo, ProxNodo, PassoCusto),
	\+member(ProxNodo, Caminho),
	NovoCusto is Custo + PassoCusto,
	estima(ProxNodo, Est).
adjacente2([Nodo|Caminho]/Custo/_, [ProxNodo,Nodo|Caminho]/NovoCusto/Est) :-
	estrada(_,ProxNodo, Nodo, PassoCusto),
	\+member(ProxNodo, Caminho),
	NovoCusto is Custo + PassoCusto,
	estima(ProxNodo, Est).

inverso(Xs, Ys):-
	inverso(Xs, [], Ys).

inverso([], Xs, Xs).
inverso([X|Xs],Ys, Zs):-
	inverso(Xs, [X|Ys], Zs).

seleciona(E, [E|Xs], Xs).
seleciona(E, [X|Xs], [X|Ys]) :- seleciona(E, Xs, Ys).


replace(OldFact, NewFact) :-
    retract(OldFact),
    assert(NewFact).

entregaRealizada(IdEstafeta, IdEnc, Trans):- replace(entrega(I,IdEstafeta,IdEnc,D,A,porDefinir),entrega(I,IdEstafeta,IdEnc,D, A,Trans)),
                                               replace(encomenda(IdEnc,P, V, C,Pz,R,Pc,emDistribuicao), encomenda(IdEnc,P, V, C,Pz,R,Pc,efetuada)).
