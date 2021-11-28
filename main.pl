%Retirar de comentário estas linhas para correr como um programa nativo no linux ./main.pl

%#!/usr/bin/env swipl
%:- initialization(main, main).


%carregar a base de conhecimento atual
:- consult('baseDeConhecimento.pl').

%Loop principal que implementa o menu de interação com a aplicação
%Nota:\u001b[32m é o código de cor para verde, \u001b[34m é o código de cor para vermelho e \u001b[0m é o código de reset de cor
%As cores só funcionam em terminais unix
main :- repeat,
	write('\u001b[32mGreen distribution\u001b[0m 🌲 --------------------------------------------------------------------------'),nl,
	write('\u001b[34m[1]\u001b[0m Identificar estafeta que utilizou mais vezes um meio de transporte mais ecológico'),nl,
	write('\u001b[34m[2]\u001b[0m Identificar que estafetas entregaram determinada(s) encomenda(s) a um determinado cliente'),nl,
	write('\u001b[34m[3]\u001b[0m Identificar os clientes servidos por um determinado estafeta'),nl,
	write('\u001b[34m[4]\u001b[0m Calcular o valor faturado pela Green Distribution num determinado dia'),nl,
	write('\u001b[34m[5]\u001b[0m Identificar as zonas com maior volume de entregas'),nl,
	write('\u001b[34m[6]\u001b[0m Calcular a classificação média de satisfação dos cliente para um determinado estafeta'),nl,
	write('\u001b[34m[7]\u001b[0m Número total de entregas pelos diferentes meios de transporte num intervalo de tempo'),nl,
	write('\u001b[34m[8]\u001b[0m Número total de entregas por estafetas, num intervalo de tempo'),nl,
	write('\u001b[34m[9]\u001b[0m Calcular o número de encomendas entregues e não entregues'),nl,
	write('\u001b[34m[10]\u001b[0m Calcular o peso total transportado por estafeta num determinado dia'),nl,
	write('\u001b[34m[11]\u001b[0m Sair'),nl,
	nl,
	write('Insira escolha: '),nl,
	read(Escolha),
	validaEscolha(Escolha),
	executa(Escolha),
  	nl,nl,fail.
 
%Função que valida as escolhas feitas( se estão entre 1 e 10)  
validaEscolha(X) :- X =< 0,write('\u001b[31mEscolha inválida\u001b[0m'),nl,!,fail.
validaEscolha(X) :- X > 11,write('\u001b[31mEscolha inválida\u001b[0m'),nl,!,fail.
validaEscolha(_).

%Função que chama as funções que implementam as funcionalidades
executa(X) :- X =:= 1, write('\u001b[31mNão implementado!\u001b[0m'). 
executa(X) :- X =:= 2, write('\u001b[31mNão implementado!\u001b[0m').  
executa(X) :- X =:= 3, write('Insira Nome Estafeta: '),nl,
		       read(Nome),
		       identificaClientesByEstafeta(Nome,L),nl,
		       write('[Lista de Clientes associados] ------------------'),nl,
		       write('Identificador - Nome - NIF - Encomenda'),nl,
		       printList(L),write('--------------------------------------------------'),!.
executa(X) :- X =:= 4, write('\u001b[31mNão implementado!\u001b[0m'). 
executa(X) :- X =:= 5, write('\u001b[31mNão implementado!\u001b[0m'). 
executa(X) :- X =:= 6, write('Insira Nome Estafeta: '),nl,
		       read(Nome),
		       calculaRankingEstafetaPorCliente(Nome,Ranking),nl,
		       write('Ranking: '),write(Ranking),write(' ⭐'),nl,!. 
executa(X) :- X =:= 7, write('\u001b[31mNão implementado!\u001b[0m').  
executa(X) :- X =:= 8, write('\u001b[31mNão implementado!\u001b[0m').  
executa(X) :- X =:= 9, getAllEntregas(LEntregas),
		       getAllEncomendas(LEncomendas),
		       statusEncomendas(LEncomendas,LEntregas,[],[],LEncNaoEntregues,LEncEntregues),
		       write('[Lista de encomendas entregues] -----------------'),nl,
		       printList(LEncEntregues),nl,
		       write('[Lista de encomendas não entregues] -------------'),nl,
		       printList(LEncNaoEntregues),
		       write('----------------------------------------------'),nl,!.
executa(X) :- X =:= 10, write('\u001b[31mNão implementado!\u001b[0m').
executa(X) :- X =:= 11, halt.


%Funções auxiliares gerais ------------------------------------------

%Predicado not
not(X) :- X, !, fail.
not(_X).

%Adicionar um elemento a uma lista
adicionarElemLista(X,[],[X]).
adicionarElemLista(X,L,[X|L]).

%Fazer o print de uma lista
printList([]) :- write('Empty list'),nl.
printList([X]) :- write(X),nl.
printList([X|XS]) :- write(X),nl,printList(XS).
printList(_) :- write('Not a list'),nl.

%Getters
getEstafetaPorNome(Nome,X) :-  findall(estafeta(Id,Nome,Encomendas),estafeta(Id,Nome,Encomendas),[X|_]).

getEncomendaPorId(Id,X) :- findall(encomenda(Id, Peso, Volume, Cliente, Prazo,Rua,Transporte, Preco),
			   encomenda(Id, Peso, Volume, Cliente, Prazo,Rua,Transporte, Preco),[X|_]).

getClientePorId(Id,X) :- findall(cliente(Id,Nome,Nif,Encomenda),cliente(Id,Nome,Nif,Encomenda),[X|_]).

getAllClientesPorId(Id,X) :- findall(cliente(Id,Nome,Nif,Encomenda),cliente(Id,Nome,Nif,Encomenda),X).

getEntregaPorIdEncomenda(Id,X) :- findall(entrega(Id,IdEstafeta,IdEncomenda,Data,Avaliacao),entrega(Id,IdEstafeta,IdEncomenda,Data,Avaliacao),[X|_]).

getAllEntregas(X) :- findall(entrega(Id,IdEstafeta,IdEncomenda,Data,Avaliacao),entrega(Id,IdEstafeta,IdEncomenda,Data,Avaliacao),X).

getAllEncomendas(X) :- findall(encomenda(Id, Peso, Volume, Cliente, Prazo,Rua,Transporte, Preco),
			   encomenda(Id, Peso, Volume, Cliente, Prazo,Rua,Transporte, Preco),X).

% 3. Identificar os clientes servidos por um determinado estafeta (Nome -> [Clientes])--------------------------------------------------------------------------
identificaClientesByEstafeta(Nome,NListaClientes) :- getEstafetaPorNome(Nome,estafeta(_,_,ListaEncomendas)),
				      		     clientesListaEncomendas(ListaEncomendas,[],NListaIdClientes),
				      		     constroiListaClienteDadoId(NListaIdClientes,[],NListaClientes).

%Função que dada uma lista de encomendas devolve uma lista de Ids de clientes associados ([Encomenda] -> [Lista de Ids Clientes Inicial ([])] -> [Id de Cliente])
clientesListaEncomendas([],[],[]).
clientesListaEncomendas([IdEncomenda],ListaIdClientes,NListaIdClientes) :- getEncomendaPorId(IdEncomenda,encomenda(_,_,_,IdCliente,_,_,_,_)),
							  		   adicionarElemLista(IdCliente,ListaIdClientes,NListaIdClientes).
clientesListaEncomendas([X|XS],ListaIdClientes,N2ListaIdClientes) :- getEncomendaPorId(X,encomenda(_,_,_,IdCliente,_,_,_,_)),
						 		     adicionarElemLista(IdCliente,ListaIdClientes,NListaIdClientes),
						                     clientesListaEncomendas(XS,NListaIdClientes,N2ListaIdClientes).

%Função que dada uma lista de Ids de cliente devolve a lista de clientes ([Id Cliente] -> [Lista de Clientes Inicial ([])] -> [Cliente])
constroiListaClienteDadoId([],[],[]).
constroiListaClienteDadoId([Id],ListaClientes,NListaClientes) :- getClientePorId(Id,Cliente),
								 adicionarElemLista(Cliente,ListaClientes,NListaClientes).
constroiListaClienteDadoId([X|XS],ListaClientes,N2ListaClientes) :- getClientePorId(X,Cliente),
							            adicionarElemLista(Cliente,ListaClientes,NListaClientes),
						    		    constroiListaClienteDadoId(XS,NListaClientes,N2ListaClientes).

% 6.Calcular a classificação média de satisfação dos cliente para um determinado estafeta -----------------------------------------------------------------------

calculaRankingEstafetaPorCliente(NomeEstafeta,Ranking) :- getEstafetaPorNome(NomeEstafeta,estafeta(_,_,ListaEncomendas)),
							  calculaRanking(ListaEncomendas,SomaRanking,NumeroDeAval),
							  Ranking is SomaRanking / NumeroDeAval.

						  
%Transforma lista de clientes em lista de Id Encomendas ([Cliente] -> [Lista de Id Encomendas Inicial ([])] -> [IdEncomendas])
encomendasCliente([],[],[]).
encomendasCliente([cliente(_,_,_,IdEncomenda)],ListaEncomendas,NListaEncomendas) :- adicionarElemLista(IdEncomenda,ListaEncomendas,NListaEncomendas).
encomendasCliente([cliente(_,_,_,IdEncomenda)|XS],ListaEncomendas,N2ListaEncomendas) :- adicionarElemLista(IdEncomenda,ListaEncomendas,NListaEncomendas),
										      encomendasCliente(XS,NListaEncomendas,N2ListaEncomendas).

%Calcular o ranking ([Id Encomenda] -> Soma dos Rankings -> Número de Ranking)
calculaRanking([],0,0).
calculaRanking([IdEncomenda],Avaliacao,1) :- getEntregaPorIdEncomenda(IdEncomenda,entrega(_,_,_,_,Avaliacao)).
calculaRanking([IdEncomenda|XS],N2,C2) :- getEntregaPorIdEncomenda(IdEncomenda,entrega(_,_,_,_,Avaliacao)), 
						       calculaRanking(XS,N,C),
						       N2 is N + Avaliacao,
						       C2 is C+1.
						   
% 9. Calcular o número de encomendas entregues e não entregues([Encomenda] -> [Entregas] -> [] -> [] -> [Encomendas Não Entregues] -> [Encomendas Entregues] ) -

statusEncomendas([],[],[],[],[],[]).
statusEncomendas([encomenda(Id,_,_,_,_,_,_,_)],LIdEntregas,LEncEntregues,LEncNaoEntregues,NLEncEntregues,NLEncNaoEntregues) :-
					verificaEncomenda(Id,LIdEntregas,LEncEntregues,LEncNaoEntregues,NLEncEntregues,NLEncNaoEntregues).
statusEncomendas([encomenda(Id,_,_,_,_,_,_,_)|XS],LIdEntregas,LEncEntregues,LEncNaoEntregues,N2LEncEntregues,N2LEncNaoEntregues) :- 
					verificaEncomenda(Id,LIdEntregas,LEncEntregues,LEncNaoEntregues,NLEncEntregues,NLEncNaoEntregues),
					statusEncomendas(XS,LIdEntregas,NLEncEntregues,NLEncNaoEntregues,N2LEncEntregues,N2LEncNaoEntregues).	
														   
verificaEncomenda(Id,ListaIdEntregas,LEncEntregues,_LEncNaoEntregues,NLEncEntregues,_NLEncNaoEntregues) :- member(Id,ListaIdEntregas),
					 					adicionarElemLista(Id,LEncEntregues,NLEncEntregues).
verificaEncomenda(Id,ListaIdEntregas,_LEncEntregues,LEncNaoEntregues,_NLEncEntregues,NLEncNaoEntregues) :- not(member(Id,ListaIdEntregas)),
					 					adicionarElemLista(Id,LEncNaoEntregues,NLEncNaoEntregues).
					 					
%---------------------------------------------------------------------------------------------------------------------------------------------------------------
