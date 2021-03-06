%#!/usr/bin/env swipl
%:- initialization(main, main).


%carregar a base de conhecimento atual
:- consult('baseConhecimentoGrafo.pl').
:- discontiguous seleciona/3.

%Loop principal que implementa o menu de interação com a aplicação
%Nota:\u001b[32m é o código de cor para verde, \u001b[34m é o código de cor para vermelho e \u001b[0m é o código de reset de cor
%As cores só funcionam em terminais unix
main :- write('\033[H\033[2J'),
	repeat,
	write('\u001b[32mGreen distribution\u001b[0m 🌲 --------------------------------------------------------------------------'),nl,
	write('\u001b[34m[1]\u001b[0m Encontrar circuito utilizado  (Heurística A*)'),nl,
	write('\u001b[34m[2]\u001b[0m Encontrar circuito utilizado (Greddy search)'),nl,
	write('\u001b[34m[3]\u001b[0m Encontrar circuito utilizado (DFS)'),nl,
	write('\u001b[34m[4]\u001b[0m Encontrar circuito utilizado (BFS)'),nl,
	write('\u001b[34m[5]\u001b[0m Encontrar circuito utilizado com profundidade limitada)'),nl,
	write('\u001b[34m[6]\u001b[0m Sair'),nl,
	nl,
	write('Insira escolha: '),nl,
	read(Escolha),
	validaEscolha(Escolha),
	executa(Escolha),
  	nl,nl,fail.
 
%Função que valida as escolhas feitas( se estão entre 1 e 6)  
validaEscolha(X) :- X =< 0,write('\u001b[31mEscolha inválida\u001b[0m'),nl,!,fail.
validaEscolha(X) :- X > 6,write('\u001b[31mEscolha inválida\u001b[0m'),nl,!,fail.
validaEscolha(_).

%Função que chama as funções que implementam as funcionalidades
executa(X) :- X =:= 1, nl,write('Insira o ID do estafeta'),nl,
			  read(IdEstafeta),nl,
			  transPossiveisAestrela(IdEstafeta,Trans,C,TempFinal,PT,PZ,Dist),
			  inverso(C,Cinv),
			  nomeTr([Trans],T),
			  nomeRua(Cinv,CN),
			  write('Peso da encomenda: '), write(PT),nl,
			  write('Prazo de entrega(horas): '), write(PZ),nl,
			  write('Nome do transporte: '), printList(T),
			  write('Tempo da entrega:'),write(TempFinal),nl,
			  write('Percurso: '),nl,
			  printList(CN),nl,write('Distância: '),write(Dist),nl,!.
executa(X) :- X =:= 2, nl, write('Insira ID Estafeta : '),nl,
                            read(IDestafeta),nl,
			     transPossiveis(IDestafeta,Trans,C,TempFinal,PT,PZ,Dist),
			     inverso(C,Cinv),
			     nomeTr([Trans],T),
			     nomeRua(Cinv,CN),
			     write('Peso da encomenda: '), write(PT),nl,
			     write('Prazo de entrega(horas): '), write(PZ),nl,
			     write('Nome do transporte: '), printList(T),
			     write('Tempo da entrega:'),write(TempFinal),nl,
			     write('Percurso: '),nl,
			     printList(CN),nl,write('Distância: '),write(Dist),nl,!.
executa(X) :- X =:= 3, nl,write('Insira o ID do estafeta'),nl,
					read(IdEstafeta),nl,
					transPossiveisDFS(IdEstafeta,Trans,C,TempFinal,PT,PZ,Dist),
					inverso(C,Cinv),
					nomeTr([Trans],T),
			     	nomeRua(Cinv,CN),
				    write('Peso da encomenda: '), write(PT),nl,
				    write('Prazo de entrega(horas): '), write(PZ),nl,
				    write('Nome do transporte: '), printList(T),
				    write('Tempo da entrega:'),write(TempFinal),nl,
				    write('Percurso: '),nl,
				    printList(CN),nl,write('Distância: '),write(Dist),nl,!.
executa(X) :- X =:= 4, nl,write('Insira o ID do estafeta'),nl,
					read(IdEstafeta),nl,
					transPossiveisBFS(IdEstafeta,Trans,C,TempFinal,PT,PZ,Dist),
					inverso(C,Cinv),
					nomeTr([Trans],T),
			     	nomeRua(Cinv,CN),
				    write('Peso da encomenda: '), write(PT),nl,
				    write('Prazo de entrega(horas): '), write(PZ),nl,
				    write('Nome do transporte: '), printList(T),
				    write('Tempo da entrega:'),write(TempFinal),nl,
				    write('Percurso: '),nl,
				    printList(CN),nl,write('Distância: '),write(Dist),nl,!.
executa(X) :- X =:= 5, nl,write('Insira o ID do estafeta'),nl,
					read(IdEstafeta),nl,
					write('Insira a Profundidade'),nl,
					read(Profundidade),nl,
					transPossiveisDFSlim(IdEstafeta,Trans,C,TempFinal,PT,PZ,Profundidade,Dist	),
					inverso(C,Cinv),
					nomeTr([Trans],T),
			     	nomeRua(Cinv,CN),
				    write('Peso da encomenda: '), write(PT),nl,
				    write('Prazo de entrega(horas): '), write(PZ),nl,
				    write('Nome do transporte: '), printList(T),
				    write('Tempo da entrega:'),write(TempFinal),nl,
				    write('Percurso: '),nl,
				    printList(CN),nl,write('Distância: '),write(Dist),nl,!.
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


dfs(Nodo,NodoFinal,[Nodo|Caminho],C) :- profundidade(Nodo,NodoFinal,[Nodo],Caminho,C).


profundidade(Nodo,NodoFinal,_,[],0) :- Nodo=:=NodoFinal.

profundidade(Nodo,NodoFinal,Historico,[ProxNodo|Caminho],Distancia) :- 
    adjacente(Nodo,ProxNodo,Distancia1),
    not(member(ProxNodo,Historico)),
    profundidade(ProxNodo,NodoFinal,[ProxNodo|Historico],Caminho,Distancia2), Distancia is Distancia1+Distancia2.

adjacente(Nodo, ProxNodo,Distancia) :- estrada(_,Nodo,ProxNodo,Distancia).
adjacente(Nodo, ProxNodo,Distancia) :- estrada(_,ProxNodo,Nodo,Distancia).

% DFS limitada 

dfslim(Nodo,NodoFinal,[Nodo|Caminho],Dist,Profundidade) :- profundidadelim(Nodo,NodoFinal,[Nodo],Caminho,Dist,Profundidade).

profundidadelim(_,_,_,_,_,0) :- !, fail.
profundidadelim(Nodo,NodoFinal,_,[],0,_) :- Nodo=:=NodoFinal.

profundidadelim(Nodo,NodoFinal,Historico,[ProxNodo|Caminho],Distancia,Profundidade) :- 
    adjacente(Nodo,ProxNodo,Distancia1),
    not(member(ProxNodo,Historico)),
    Profundidade1 is Profundidade-1,
    profundidadelim(ProxNodo,NodoFinal,[ProxNodo|Historico],Caminho,Distancia2,Profundidade1), Distancia is Distancia1+Distancia2.




% BFS

breadth_first(Orig, Dest, Cam):- bfs(Dest,[[Orig]],Cam).
									%bfsDist(Cam, D).


bfsDist([X,Y], D) :- adjacente(X,Y,D).
bfsDist([X,Y|T], D) :- adjacente(X,Y,D1),
								bfsDist([Y|T], D2),
								D is D1+D2.		 


bfs(EstadoF,[[EstadoF|T]|_],Solucao)  :- reverse([EstadoF|T],Solucao).
bfs(EstadoF,[EstadoA|Outros],Solucao) :- 
    EstadoA = [F|_],
    findall([X|EstadoA],
            (EstadoF\==F,
            adjacente(X,F,_Distancia),
            not(member(X,EstadoA))),
            Novos),
    append(Outros,Novos,Todos),
    bfs(EstadoF,Todos,Solucao).

% A estrela ------

resolveAestrelaLista([IdRua],FULL/Custo) :- 
        resolve_aestrela(1,IdRua,FULL/Custo).
        
resolveAestrelaLista([IdRua,IdRua2|T1],FULL/Custo) :-
           resolve_aestrela(IdRua, IdRua2, Caminho/CustoTmp),
           resolveAestrelaLista([IdRua2|T1],F1/C1),
           tail(F1,FTemp),
		   inverso(Caminho,CaminhoInverso),
           append(CaminhoInverso, FTemp, FULL),
           Custo is C1+CustoTmp.

resolve_aestrela(Goal,Nodo, Caminho/Custo) :-
	estima(Goal,Nodo, Estima),
	aestrela([[Nodo]/0/Estima], InvCaminho/Custo/_,Goal),
	inverso(InvCaminho, Caminho).

aestrela(Caminhos, Caminho,Goal) :-
	obtem_melhor(Caminhos, Caminho),
	Caminho = [Nodo|_]/_/_,
	Nodo =:= Goal.

aestrela(Caminhos, SolucaoCaminho,Goal) :-
	obtem_melhor(Caminhos, MelhorCaminho),
	seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
	expande_aestrela(MelhorCaminho, ExpCaminhos,Goal),
	append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
    aestrela(NovoCaminhos, SolucaoCaminho,Goal).	

obtem_melhor([Caminho], Caminho) :- !.
obtem_melhor([Caminho1/Custo1/Est1,_/Custo2/Est2|Caminhos], MelhorCaminho) :-
	Custo1 + Est1 =< Custo2 + Est2, !,
	obtem_melhor([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho). 
obtem_melhor([_|Caminhos], MelhorCaminho) :- 
	           obtem_melhor(Caminhos, MelhorCaminho).



expande_aestrela(Caminho, ExpCaminhos,Goal) :-
	findall(NovoCaminho, adjacente2(Caminho,NovoCaminho,Goal), ExpCaminhos).

%Auxiliares para definir ruas das encomenda----------------------------------------------------------------------------------

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
				
%getRuasDoEstafeta(IdEst,T):- findall(L,estafeta(IdEst,_,L),[Lenc|_]),
%			      findall(Idenc,(member(Idenc,Lenc), not(entrega(_,_,Idenc,_,_,_))),L),
%			      findall(Idrua/Peso/Prazo/Idenc,(member(Idenc,L),encomenda(Idenc,Peso,_,_,Prazo,Idrua,_,_)),T).

getRuasDoEstafeta(IdEst,T):- findall(L,estafeta(IdEst,_,L),[Lenc|_]),
			      findall(Idrua/Peso/Prazo/Idenc,(member(Idenc,Lenc),encomenda(Idenc,Peso,_,_,Prazo,Idrua,_,emDistribuicao,_)),T).
					

getPesoTotal([],0).
getPesoTotal([_/Peso/_/_],Peso).
getPesoTotal([_/P/_/_,_/P2/_/_|T], Peso) :- P3 is P+P2,
                                 getPesoTotal(T,Ps),
                                 Peso is P3 + Ps.
getPrazo([_/_/Prazo/_], Prazo).
getPrazo([_/_/Pz/_|T], Prazo) :-
    getPrazo(T, TPrazo),
    Prazo is min(Pz, TPrazo). 
    
    
getEstimaCusto(Id/_/_/_,D/Id):- findall(D,estima(1,Id,D),[D|_]).

retiraC(_/ID,ID).
retiraID(ID/_/_/_,ID).

getRuasOrdenadas(Le, Sorted):- maplist(getEstimaCusto(), Le, List), sort(0, @=<, List,  LS), maplist(retiraC(),LS, Sorted).
getRuasOrdenadasPorID(L,LResult) :- sort(0,@=<,L,LSorted),maplist(retiraID(),LSorted, LResult).

transPossiveis(Idest, Trans,C,TF,PesoT,Prazo,Dist) :- getRuasDoEstafeta(Idest,LRuas), 
                                     getRuasOrdenadas(LRuas,LRuasOrd), 
                                     resolve(LRuasOrd,C/Dist), 
                                     getPesoTotal(LRuas,PesoT),
                                     getPrazo(LRuas,Prazo),
                                     ((PesoT=<100,PesoT>20) -> Trans is 3;
                                     (PesoT=<20,PesoT>5) -> escolheM_C(Dist,Trans,Prazo,PesoT,TF);%mota ou carro
                                     (PesoT>0,PesoT=<5) -> escolheMaisEco(Dist,Trans,Prazo,PesoT,TF)).%bicicleta, mota ou carro

transPossiveisBFS(Idest,Trans,C,TF,PesoT,Prazo,Dist) :- getRuasDoEstafeta(Idest,LRuas), 
                                     getRuasOrdenadas(LRuas,LRuasOrd), 
                                     resolveBFS(LRuasOrd,C,Dist), 
                                     getPesoTotal(LRuas,PesoT),
                                     getPrazo(LRuas,Prazo),
                                     ((PesoT=<100,PesoT>20) -> Trans is 3;
                                     (PesoT=<20,PesoT>5) -> escolheM_C(Dist,Trans,Prazo,PesoT,TF);%mota ou carro
                                     (PesoT>0,PesoT=<5) -> escolheMaisEco(Dist,Trans,Prazo,PesoT,TF)).%bicicleta, mota ou carro

transPossiveisDFS(Idest,Trans,C,TF,PesoT,Prazo,Dist) :- getRuasDoEstafeta(Idest,LRuas), 
                                     getRuasOrdenadas(LRuas,LRuasOrd), 
                                     resolveDFS(LRuasOrd,C,Dist), 
                                     getPesoTotal(LRuas,PesoT),
                                     getPrazo(LRuas,Prazo),
                                     ((PesoT=<100,PesoT>20) -> Trans is 3;
                                     (PesoT=<20,PesoT>5) -> escolheM_C(Dist,Trans,Prazo,PesoT,TF);%mota ou carro
                                     (PesoT>0,PesoT=<5) -> escolheMaisEco(Dist,Trans,Prazo,PesoT,TF)).%bicicleta, mota ou carro

transPossiveisDFSlim(Idest,Trans,C,TF,PesoT,Prazo,Profundidade,Dist) :- getRuasDoEstafeta(Idest,LRuas), 
                                     getRuasOrdenadas(LRuas,LRuasOrd), 
                                     resolveDFSlim(LRuasOrd,C,Dist,Profundidade), 
                                     getPesoTotal(LRuas,PesoT),
                                     getPrazo(LRuas,Prazo),
                                     ((PesoT=<100,PesoT>20) -> Trans is 3;
                                     (PesoT=<20,PesoT>5) -> escolheM_C(Dist,Trans,Prazo,PesoT,TF);%mota ou carro
                                     (PesoT>0,PesoT=<5) -> escolheMaisEco(Dist,Trans,Prazo,PesoT,TF)).%bicicleta, mota ou carro

transPossiveisAestrela(Idest,Trans,C,TF,PesoT,Prazo,Dist) :-  getRuasDoEstafeta(Idest,LRuas), 
						  			getRuasOrdenadasPorID(LRuas,LRuasOrd), 
                          			resolveAestrelaLista(LRuasOrd,C/Dist),
									getPesoTotal(LRuas,PesoT),
                                    getPrazo(LRuas,Prazo),
									((PesoT=<100,PesoT>20) -> Trans is 3;
                                     (PesoT=<20,PesoT>5) -> escolheM_C(Dist,Trans,Prazo,PesoT,TF);%mota ou carro
                                     (PesoT>0,PesoT=<5) -> escolheMaisEco(Dist,Trans,Prazo,PesoT,TF)).%bicicleta, mota ou carro


%Tem todas as ruas das entregas
resolve([IdRua],FULL/Custo) :- 
        resolve_gulosa(IdRua,1,FULL/Custo).
        
resolve([IdRua,IdRua2|T1],FULL/Custo) :-
           resolve_gulosa(IdRua, IdRua2, Caminho/CustoTmp),
           resolve([IdRua2|T1],F1/C1),
           tail(F1,FTemp),
           append(Caminho, FTemp, FULL),
           Custo is C1+CustoTmp.

resolveDFS([IdRua],Caminho,Custo):-
			dfs(IdRua,1,Caminho,Custo).

resolveDFS([IdRua,IdRua2|T1],FULL,Custo) :-
           dfs(IdRua,IdRua2,Caminho,CustoTmp),
           resolveDFS([IdRua2|T1],F1,C1),
           tail(F1,FTemp),
           append(Caminho, FTemp, FULL),
           Custo is C1+CustoTmp.

resolveDFSlim([IdRua],Caminho,Custo,Profundidade):-
			dfslim(IdRua,1,Caminho,Custo,Profundidade).

resolveDFSlim([IdRua,IdRua2|T1],FULL,Custo,Profundidade) :-
           dfslim(IdRua,IdRua2,Caminho,CustoTmp,Profundidade),
           resolveDFS([IdRua2|T1],F1,C1),
           tail(F1,FTemp),
           append(Caminho, FTemp, FULL),
           Custo is C1+CustoTmp.

resolveBFS([IdRua],Caminho,Custo):-
			breadth_first(IdRua,1,Caminho),
			bfsDist(Caminho, Custo).
resolveBFS([IdRua,IdRua2|T1],FULL, Custo) :-
           breadth_first(IdRua, IdRua2, Caminho),
           bfsDist(Caminho, Dist),
           resolveBFS([IdRua2|T1],F1, C1),
           tail(F1,FTemp),
           append(Caminho, FTemp, FULL),
           Custo is C1+Dist.

%Gulosa----------------------------------------------------------------------------------
resolve_gulosa(Origem, Destino, CaminhoDistancia/CustoDist) :-
        getEstimaG(Origem,Destino,EstimaD),
	agulosa_distancia_g([[Origem]/0/EstimaD], InvCaminho/CustoDist/_,Destino),
	reverse(InvCaminho, CaminhoDistancia).


agulosa_distancia_g(Caminhos, Caminho,Destino) :-
	obtem_melhor_distancia_g(Caminhos, Caminho),
	Caminho = [Nodo|_]/_/_,
	Nodo == Destino.
agulosa_distancia_g(Caminhos, SolucaoCaminho, Destino) :-
	obtem_melhor_distancia_g(Caminhos, MelhorCaminho),
	seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
	expande_agulosa_distancia_g(MelhorCaminho, ExpCaminhos,Destino),
	append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
        agulosa_distancia_g(NovoCaminhos, SolucaoCaminho, Destino).	


obtem_melhor_distancia_g([Caminho], Caminho) :- !.
obtem_melhor_distancia_g([Caminho1/Custo1/Est1,_/_/Est2|Caminhos], MelhorCaminho) :-
	Est1 =< Est2, !,
	obtem_melhor_distancia_g([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho). 
obtem_melhor_distancia_g([_|Caminhos], MelhorCaminho) :- 
	obtem_melhor_distancia_g(Caminhos, MelhorCaminho).
	

expande_agulosa_distancia_g(Caminho, ExpCaminhos,Destino) :-
	findall(NovoCaminho, adjacente2(Caminho,NovoCaminho, Destino), ExpCaminhos). % ver este destino
	


adjacente2([Nodo|Caminho]/Custo/_, [ProxNodo,Nodo|Caminho]/NovoCusto/EstDist, Destino) :-
	getEstrada(Nodo, ProxNodo, PassoCustoDist),
	\+ member(ProxNodo, Caminho),
	NovoCusto is Custo + PassoCustoDist,
	estima(ProxNodo, Destino, EstDist).
adjacente2([Nodo|Caminho]/Custo/_, [ProxNodo,Nodo|Caminho]/NovoCusto/EstDist, Destino) :-
	getEstrada(Nodo, ProxNodo, PassoCustoDist),
	\+ member(ProxNodo, Caminho),
	NovoCusto is Custo + PassoCustoDist,
	estima( Destino,ProxNodo, EstDist).	
	
	
seleciona(E, [E|Xs], Xs).
seleciona(E, [X|Xs], [X|Ys]) :- seleciona(E, Xs, Ys).


getEstimaG(Origem, Destino, Distancia):- estima(Origem, Destino, Distancia).
getEstimaG(Origem, Destino, Distancia):- !, estima(Destino, Origem, Distancia).

getEstrada(Origem, Destino, Distancia):- estrada(_,Origem, Destino, Distancia).
getEstrada(Origem, Destino, Distancia):- !, estrada(_,Destino, Origem, Distancia).



tail([], []).
tail([_|T],T).

inverso(Xs, Ys):-
	inverso(Xs, [], Ys).

inverso([], Xs, Xs).
inverso([X|Xs],Ys, Zs):-inverso(Xs, [X|Ys], Zs).

seleciona(E,[E|Xs],Xs).
seleciona(E,[X|Xs],[X|Ys]):-seleciona(E, Xs, Ys).


replace(OldFact, NewFact) :-
    retract(OldFact),
    assert(NewFact).

entregaRealizada(IdEstafeta, IdEnc, Trans):- replace(entrega(I,IdEstafeta,IdEnc,D,A,porDefinir),entrega(I,IdEstafeta,IdEnc,D, A,Trans)),
                                             replace(encomenda(IdEnc,P, V, C,Pz,R,Pc,emDistribuicao), encomenda(IdEnc,P, V, C,Pz,R,Pc,efetuada)).


%identificar quais as rotas com maior número de entregas (por volume e peso)

getRuaPeso(Idrua,P):- encomenda(_,P,_,_,_,Idrua,_,_,_).

pesoRota([]/_,0).
pesoRota([Id]/I,P/I):- getRuaPeso(Id,P).
pesoRota([ID,ID2|T]/I,P/I):- getRuaPeso(ID,P1),
			    getRuaPeso(ID2,P2), 
			    P3 is P1+P2, 
			    pesoRota(T/I,PT/I), 
			    P is PT+P3.


pesoRotas(Le, Sorted):- maplist(pesoRota(), Le, L),sort(0, @>=, L,  Sorted).



rotaMaisPesada(Peso,Rota):- findall(L/Id,rota(Id,L),T), pesoRotas(T,[Peso/Rota|_]).

getRuaVolume(Idrua,V):- encomenda(_,_,V,_,_,Idrua,_,_,_).

volumeRota([]/_,0).
volumeRota([Id]/I,V/I):- getRuaVolume(Id,V).
volumeRota([ID,ID2|T]/I,V/I):- getRuaVolume(ID,V1),
			    getRuaVolume(ID2,V2),
			    V3 is V1+V2, 
			    volumeRota(T/I,VT/I), 
			    V is VT+V3.


volumeRotas(Le, Sorted):- maplist(volumeRota(), Le, List), sort(0, @>=, List,  Sorted).



rotaMaisVolumosa(Volume,Rota):- findall(L/Id,rota(Id,L),T), volumeRotas(T,[Volume/Rota|_]).

%Escolher a rota mais rápida (usando o critério da distância);
dist([IdRua,IdRua2]/I,Custo/I) :- 
        getEstrada(IdRua,IdRua2,Custo).
        
dist([IdRua,IdRua2|T1]/I,Custo/I) :-
           getEstrada(IdRua, IdRua2, CustoTmp),
           dist([IdRua2|T1]/I,C1/I),
           Custo is C1+CustoTmp.

distRotas(Le, Sorted):- maplist(dist(), Le, L),sort(0, @=<, L,  Sorted).



rotaMenosDist(Distancia,Rota):- findall(L/Id,rota(Id,L),T), distRotas(T,[Distancia/Rota|_]).


