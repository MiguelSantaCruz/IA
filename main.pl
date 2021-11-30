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
executa(X) :- X =:= 2, write('Insira ID Cliente'),nl,
			   read(Id),
			   identificaEstafetaByCliente(Id,Estafetas),nl,
			   printList(Estafetas),nl,!.
executa(X) :- X =:= 3, write('Insira Nome Estafeta: '),nl,
		       read(Nome),
		       identificaClientesByEstafeta(Nome,L),nl,
		       write('\u001b[35m[Lista de Clientes associados]\u001b[0m ------------------'),nl,
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
executa(X) :- X =:= 9, nl,write('Insira data inicial (dd-mm-aaaa-hh-mm) :'),nl,
		       read(DiaInicial-MesInicial-AnoInicial-HoraInicial-MinutoInicial),nl,
		       write('Insira data final (dd-mm-aaaa-hh-mm) :'),nl,
		       read(DiaFinal-MesFinal-AnoFinal-HoraFinal-MinutoFinal),nl,
		       getAllEntregas(LEntregas),	
		       filtraEntregasData(LEntregas, data(DiaInicial,MesInicial,AnoInicial,HoraInicial,MinutoInicial), 
		       data(DiaFinal,MesFinal,AnoFinal,HoraFinal,MinutoFinal), [], ListaEntregasData),
		       converteListaEntregasToListaIdEncomendas(ListaEntregasData,[],ListaIdEntregas),
		       getAllEncomendas(LEncomendas),
		       statusEncomendas(LEncomendas,ListaIdEntregas,[],[],LEncNaoEntregues,LEncEntregues),
		       listIdToEncomenda(LEncEntregues,[],ListaEncomendasEntregues),
		       listIdToEncomenda(LEncNaoEntregues,[],ListaEncomendasNaoEntregues),nl,
		       write('\u001b[35m[Lista de encomendas entregues]\u001b[0m -----------------'),nl,
		       printList(ListaEncomendasEntregues),nl,
		       write('\u001b[35m[Lista de encomendas não entregues]\u001b[0m -------------'),nl,
		       printList(ListaEncomendasNaoEntregues),
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
printList([]) :- write('Sem Elementos'),nl.
printList([X]) :- write(X),nl.
printList([X|XS]) :- write(X),nl,printList(XS).
printList(_) :- write('Não é lista'),nl.

%Transformar lista de Id encomendas em lista de encomendas ([Id Encomenda] -> [](Lista auxiliar inicial) -> [Encomenda])

listIdToEncomenda([],[],[]).
listIdToEncomenda([Id],ListaEncomendas,NListaEncomendas) :- getEncomendaPorId(Id,Encomenda), adicionarElemLista(Encomenda,ListaEncomendas,NListaEncomendas).
listIdToEncomenda([Id|XS],ListaEncomendas,N2ListaEncomendas) :- getEncomendaPorId(Id,Encomenda), 
							        adicionarElemLista(Encomenda,ListaEncomendas,NListaEncomendas),
							        listIdToEncomenda(XS,NListaEncomendas,N2ListaEncomendas).



%Filtra entregas por data ([Entrega] -> data(Dia,Mes,Ano) -> data(Dia,Mes,Ano) -> [Encomendas] -> [Encomedas])
filtraEntregasData([],_,_,[],[]).
filtraEntregasData([entrega(Id,IdEstafeta,IdEncomenda,Data,Encomenda)],DataInicial,DataFinal,ListEncomendas,NListEncomendas) :- comparaData(Data,DataInicial,DataFinal),
								    adicionarElemLista(entrega(Id,IdEstafeta,IdEncomenda,Data,Encomenda),ListEncomendas,NListEncomendas),!.
filtraEntregasData([entrega(_,_,_,_,_)],_,_,ListEncomendas,NListEncomendas) :- NListEncomendas = ListEncomendas,!.
filtraEntregasData([entrega(Id,IdEstafeta,IdEncomenda,Data,Encomenda)|XS],DataInicial,DataFinal,ListEncomendas,N2ListEncomendas) :- comparaData(Data,DataInicial,DataFinal),
								    adicionarElemLista(entrega(Id,IdEstafeta,IdEncomenda,Data,Encomenda),ListEncomendas,NListEncomendas),
								    filtraEntregasData(XS,DataInicial,DataFinal,NListEncomendas,N2ListEncomendas).
filtraEntregasData([entrega(_,_,_,_,_)|XS],DataInicial,DataFinal,ListEncomendas,NListEncomendas) :-
								    filtraEntregasData(XS,DataInicial,DataFinal,ListEncomendas,NListEncomendas). 								    
%Verifica se uma dada data está entre outras duas (data(Dia,Mes,Ano,Hora,Minuto) -> data(Dia,Mes,Ano,Hora,Minuto) -> data(Dia,Mes,Ano,Hora,Minuto) -> {V,F})
comparaData(data(Dia,_,_,_,_),_,_) :- Dia =< 0, !,fail.
comparaData(data(Dia,_,__,_),_,_) :- Dia > 31, !,fail.
comparaData(_,data(DiaInicial,_,_,_,_),_) :- DiaInicial =< 0, !,fail.
comparaData(_,data(DiaInicial,_,_,_,_),_) :- DiaInicial > 31, !,fail.
comparaData(_,_,data(DiaFinal,_,_,_,_)) :- DiaFinal =< 0, !,fail.
comparaData(_,_,data(DiaFinal,_,_,_,_)) :- DiaFinal > 31, !,fail.
comparaData(data(_,Mes,_,_,_),_,_) :- Mes =< 0, !,fail.
comparaData(data(_,Mes,_,_,_),_,_) :- Mes > 12, !,fail.
comparaData(_,data(_,MesInicial,_,_,_),_) :- MesInicial =< 0, !,fail.
comparaData(_,data(_,MesInicial,_,_,_),_) :- MesInicial > 12, !,fail.
comparaData(_,_,data(_,MesFinal,_,_,_)) :- MesFinal =< 0, !,fail.
comparaData(_,_,data(_,MesFinal,_,_,_)) :- MesFinal > 12, !,fail. 
comparaData(data(_,_,Ano,_,_),data(_,_,AnoInicial,_,_),data(_,_,_,_,_)) :- Ano < AnoInicial,!,fail.
comparaData(data(_,_,Ano,_,_),data(_,_,_,_,_),data(_,_,AnoFinal,_,_)) :- Ano > AnoFinal,!,fail.
comparaData(data(_,Mes,_,_,_),data(_,MesInicial,_,_,_),data(_,_,_,_,_)) :- Mes < MesInicial,!,fail.
comparaData(data(_,Mes,_,_,_),data(_,_,_,_,_),data(_,MesFinal,_,_,_)) :- Mes > MesFinal,!,fail.
comparaData(data(Dia,_,_,_,_),data(DiaInicial,_,_,_,_),data(_,_,_,_,_)) :- Dia < DiaInicial,!,fail.
comparaData(data(Dia,_,_,_,_),data(_,_,_,_,_),data(DiaFinal,_,_,_,_)) :- Dia > DiaFinal,!,fail.
comparaData(data(_,_,_,Hora,_),data(_,_,_,HoraInicial,_),data(_,_,_,_,_)) :- Hora < HoraInicial,!,fail.
comparaData(data(_,_,_,Hora,_),data(_,_,_,_,_),data(_,_,_,HoraFinal,_)) :- Hora > HoraFinal,!,fail.
comparaData(data(_,_,_,_,Minuto),data(_,_,_,_,MinutoInicial),data(_,_,_,_,_)) :- Minuto < MinutoInicial,!,fail.
comparaData(data(_,_,_,_,Minuto),data(_,_,_,_,_	),data(_,_,_,_,MinutoFinal)) :- Minuto > MinutoFinal,!,fail.
comparaData(_,_,_).

converteListaEntregasToListaIdEncomendas([],[],[]).
converteListaEntregasToListaIdEncomendas([entrega(_,_,IdEncomenda,_,_)],ListaEncomendas,NListaEncomendas) :-
												 adicionarElemLista(IdEncomenda,ListaEncomendas,NListaEncomendas).
converteListaEntregasToListaIdEncomendas([entrega(_,_,IdEncomenda,_,_)|XS],ListaEncomendas,N2ListaEncomendas) :-
								adicionarElemLista(IdEncomenda,ListaEncomendas,NListaEncomendas),
								converteListaEntregasToListaIdEncomendas(XS,NListaEncomendas,N2ListaEncomendas).
%Getters
getEstafetaPorNome(Nome,X) :-  findall(estafeta(Id,Nome,Encomendas),estafeta(Id,Nome,Encomendas),[X|_]).

getEncomendaPorId(Id,X) :- findall(encomenda(Id, Peso, Volume, Cliente, Prazo,Rua,Transporte, Preco,Data),
			   encomenda(Id, Peso, Volume, Cliente, Prazo,Rua,Transporte, Preco,Data),[X|_]).

getClientePorId(Id,X) :- findall(cliente(Id,Nome,Nif,Encomenda),cliente(Id,Nome,Nif,Encomenda),[X|_]).

getAllClientesPorId(Id,X) :- findall(cliente(Id,Nome,Nif,Encomenda),cliente(Id,Nome,Nif,Encomenda),X).

getEntregaPorIdEncomenda(Id,X) :- findall(entrega(Id,IdEstafeta,IdEncomenda,Data,Avaliacao),entrega(Id,IdEstafeta,IdEncomenda,Data,Avaliacao),[X|_]).

getListIDEncomendaPorIdCliente(Id,X) :- findall(IdEncomenda,cliente(Id,_,_, IdEncomenda),X).

getIdEstafetaPorIdEncomenda(Id,X) :- findall(IdEstafeta,entrega(_, IdEstafeta, Id , _,_),[X|_]).

getEstafetaPorID(ID,X) :-  findall(estafeta(ID,Nome,Encomendas),estafeta(ID,Nome,Encomendas),[X|_]).

getAllEntregas(X) :- findall(entrega(Id,IdEstafeta,IdEncomenda,Data,Avaliacao),entrega(Id,IdEstafeta,IdEncomenda,Data,Avaliacao),X).

getAllIdEntregas(X) :- findall(Id,entrega(Id,_,_,_,_),X).

getAllIdEncomendasEntregas(X) :- findall(IdEncomenda,entrega(_,_,IdEncomenda,_,_),X).

getAllEncomendas(X) :- findall(encomenda(Id, Peso, Volume, Cliente, Prazo,Rua,Transporte, Preco,Data),
			   encomenda(Id, Peso, Volume, Cliente, Prazo,Rua,Transporte, Preco,Data),X).
			   
getAllIdEncomendas(X) :- findall(Id,encomenda(Id, _, _, _, _,_,_, _,_),X).

% 2. identificar que estafetas entregaram determinada(s) encomenda(s) a um determinado cliente; (id Cliente-> [Entregas] -> idEstafeta -> NomeEstafeta)--------------------------------------------------------------------------

identificaEstafetaByCliente(IdCliente,ListaEstafetas) :- getAllClientesPorId(IdCliente,ListaClientes),
									listaIdEncomendasbyListaClientes(ListaClientes,[],ListaIdEncomendas),
									listaIdEncomendasToListEncomendas(ListaIdEncomendas,[],ListaEncomendas),
									listaIdEstafetasbyListaEncomendas(ListaEncomendas,[],ListaIdEstafeta),
									listaEstafetasbyListaIdEstafetas(ListaIdEstafeta,[],ListaEstafetas).

listaIdEncomendasbyListaClientes([],[],[]).
listaIdEncomendasbyListaClientes([cliente(Id,_Nome,_Nif,_IdEncomenda)],ListaEncomendas,NListaEncomendas):- getListIDEncomendaPorIdCliente(Id,Encomendas),
											append(ListaEncomendas,Encomendas,NListaEncomendas).
listaIdEncomendasbyListaClientes([cliente(Id,_Nome,_Nif,_IdEncomenda)|T],ListaEncomendas,N2ListaEncomendas):- getListIDEncomendaPorIdCliente(Id,Encomendas),
											append(ListaEncomendas,Encomendas,NListaEncomendas),
											listaIdEncomendasbyListaClientes(T,NListaEncomendas,N2ListaEncomendas).

listaIdEncomendasToListEncomendas([],[],[]).
listaIdEncomendasToListEncomendas([IdEncomenda],ListaEncomendas,NListaEncomendas):- getEncomendaPorId(IdEncomenda,Encomenda),
											adicionarElemLista(Encomenda,ListaEncomendas,NListaEncomendas).
listaIdEncomendasToListEncomendas([IdEncomenda|T],ListaEncomendas,N2ListaEncomendas):- getEncomendaPorId(IdEncomenda,Encomenda),
											adicionarElemLista(Encomenda,ListaEncomendas,NListaEncomendas),
											listaIdEncomendasToListEncomendas(T,NListaEncomendas,N2ListaEncomendas).


listaIdEstafetasbyListaEncomendas([],[],[]).
listaIdEstafetasbyListaEncomendas([encomenda(Identificador, _, _, _, _, _,_, _,_)],ListaEstafetas,NListaEstafetas):- getIdEstafetaPorIdEncomenda(Identificador,IdEstafeta),
											adicionarElemLista(IdEstafeta,ListaEstafetas,NListaEstafetas).
listaIdEstafetasbyListaEncomendas([encomenda(Identificador, _, _, _, _, _,_, _,_)| T ],ListaEstafetas,N2ListaEstafetas):- getIdEstafetaPorIdEncomenda(Identificador,IdEstafeta),
											adicionarElemLista(IdEstafeta,ListaEstafetas,NListaEstafetas),
											listaIdEstafetasbyListaEncomendas(T,NListaEstafetas,N2ListaEstafetas).

listaEstafetasbyListaIdEstafetas([],[],[]).
listaEstafetasbyListaIdEstafetas([IdEstafeta],ListaEstafetas,NListaEstafetas):- getEstafetaPorID(IdEstafeta,Estafeta),
											adicionarElemLista(Estafeta,ListaEstafetas,NListaEstafetas).
listaEstafetasbyListaIdEstafetas([IdEstafeta | T],ListaEstafetas,N2ListaEstafetas):- getEstafetaPorID(IdEstafeta,Estafeta),
											adicionarElemLista(Estafeta,ListaEstafetas,NListaEstafetas),
											listaEstafetasbyListaIdEstafetas(T,NListaEstafetas,N2ListaEstafetas).

% 3. Identificar os clientes servidos por um determinado estafeta (Nome -> [Clientes])--------------------------------------------------------------------------
identificaClientesByEstafeta(Nome,NListaClientes) :- getEstafetaPorNome(Nome,estafeta(_,_,ListaEncomendas)),
				      		     clientesListaEncomendas(ListaEncomendas,[],NListaIdClientes),
				      		     constroiListaClienteDadoId(NListaIdClientes,[],NListaClientes).

%Função que dada uma lista de encomendas devolve uma lista de Ids de clientes associados ([Encomenda] -> [Lista de Ids Clientes Inicial ([])] -> [Id de Cliente])
clientesListaEncomendas([],[],[]).
clientesListaEncomendas([IdEncomenda],ListaIdClientes,NListaIdClientes) :- getEncomendaPorId(IdEncomenda,encomenda(_,_,_,IdCliente,_,_,_,_,_)),
							  		   adicionarElemLista(IdCliente,ListaIdClientes,NListaIdClientes).
clientesListaEncomendas([X|XS],ListaIdClientes,N2ListaIdClientes) :- getEncomendaPorId(X,encomenda(_,_,_,IdCliente,_,_,_,_,_)),
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
statusEncomendas([encomenda(Id,_,_,_,_,_,_,_,_)],LIdEntregas,LEncEntregues,LEncNaoEntregues,NLEncEntregues,NLEncNaoEntregues) :-
					verificaEncomenda(Id,LIdEntregas,LEncEntregues,LEncNaoEntregues,NLEncEntregues,NLEncNaoEntregues).
statusEncomendas([encomenda(Id,_,_,_,_,_,_,_,_)|XS],LIdEntregas,LEncEntregues,LEncNaoEntregues,N2LEncEntregues,N2LEncNaoEntregues) :- 
					verificaEncomenda(Id,LIdEntregas,LEncEntregues,LEncNaoEntregues,NLEncEntregues,NLEncNaoEntregues),
					statusEncomendas(XS,LIdEntregas,NLEncEntregues,NLEncNaoEntregues,N2LEncEntregues,N2LEncNaoEntregues).	
														   
verificaEncomenda(Id,ListaIdEntregas,LEncEntregues,_LEncNaoEntregues,NLEncEntregues,_NLEncNaoEntregues) :- member(Id,ListaIdEntregas),
					 					adicionarElemLista(Id,LEncEntregues,NLEncEntregues),!.
verificaEncomenda(Id,_,_LEncEntregues,LEncNaoEntregues,_NLEncEntregues,NLEncNaoEntregues) :- adicionarElemLista(Id,LEncNaoEntregues,NLEncNaoEntregues),!.
					 					
%---------------------------------------------------------------------------------------------------------------------------------------------------------------

%10 calcular o peso total transportado por estafeta num determinado dia

pesoTotalNumDia(IdEstafeta,Dia,Res):- listaEntregasNumDia(IdEstafeta,Dia,ListaIdEncomendas),
									listaEntregasParaPeso(ListaIdEncomendas,Res).


listaEntregasNumDia(Id,Data,Res) :- findall(Encomenda, (entrega(_,Id,Encomenda,D,_),dataSimples(D,Data)),Res).


listaEntregasParaPeso([],0).
listaEntregasParaPeso([H],PesoTotal):- encomenda(H,Peso,_,_,_,_,_,_,_),
									PesoTotal is Peso.
listaEntregasParaPeso([H|T],PesoTotal):- listaEntregasParaPeso([H],Peso1),
										listaEntregasParaPeso(T,Peso2),
										PesoTotal is Peso1 + Peso2.
										
dataSimples(data(Dia,Mes,Ano,_,_),data(Dia2,Mes2,Ano2,_,_)) :- Dia == Dia2, Mes == Mes2 , Ano == Ano2.

