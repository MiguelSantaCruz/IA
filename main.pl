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
executa(X) :- X =:= 1, estMaisEco(Max,Nome),
				print(Max),
				print(Nome),nl,!.
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
executa(X) :- X =:= 4, write('Insira data (dd-mm-aaaa-hh-mm) :'),nl,
		        read(Dia-Mes-Ano-Hora-Min),nl,
		        calculaF(data(Dia,Mes,Ano,Hora,Min),V),
		        write(V),nl,!. 
executa(X) :- X =:= 5, write('\u001b[31mNão implementado!\u001b[0m'). 
executa(X) :- X =:= 6, write('Insira Nome Estafeta: '),nl,
		       read(Nome),
		       calculaRankingEstafetaPorCliente(Nome,Ranking),nl,
		       write('Ranking: '),write(Ranking),write(' ⭐'),nl,!. 
executa(X) :- X =:= 7, write('Insira data inicial (dd-mm-aaaa-hh-mm) :'),nl,
		       read(DI-MI-AI-HI-MinI),nl,
		       write('Insira data final (dd-mm-aaaa-hh-mm) :'),nl,
		       read(DF-MF-AF-HF-MinF),nl,
		       date_time_stamp(date(AI,MI,DI,HI,MinI,0,0,-,-), Si),
		       date_time_stamp(date(AF,MF,DF,HF,MinF,0,0,-,-), Sf),
		       filtra(Si,Sf,LEnt),
		       listaEnc(LEnt,LE),
		       listaEB(LE,Lb),
		       write("bicicleta:"),
		       printList(Lb),
		       listaEM(LE,LM),
		       write("mota:"),
		       printList(LM),
		       listaEC(LE,LC),	      
		       write("carro:"),
		       printList(LC),
		       write('----------------------------------------------'),nl,!.
executa(X) :- X =:= 8, nl,write('Insira data inicial (dd-mm-aaaa-hh-mm) :'),nl,
               read(DiaInicial-MesInicial-AnoInicial-HInicial-MInicial),nl,
               write('Insira data final (dd-mm-aaaa-hh-mm) :'),nl,
               read(DiaFinal-MesFinal-AnoFinal-HFinal-MFinal),nl, 
               getAllEstafetas(Estafetas),
               numeroEntregasEstafeta(Estafetas, data(DiaInicial,MesInicial,AnoInicial,HInicial,MInicial), data(DiaFinal,MesFinal,AnoFinal,HFinal,MFinal), N),
               write(N),
               write('----------------------------------------------'),nl,!.  
executa(X) :- X =:= 9, nl,write('Insira data inicial (dd-mm-aaaa-hh-mm) :'),nl,
		       read(DiaInicial-MesInicial-AnoInicial-HInicial-MInicial),nl,
		       write('Insira data final (dd-mm-aaaa-hh-mm) :'),nl,
		       read(DiaFinal-MesFinal-AnoFinal-HFinal-MFinal),nl,
		       getAllEntregas(LEntregas),	
		       filtraEntregasData(LEntregas, data(DiaInicial,MesInicial,AnoInicial,HInicial,MInicial), data(DiaFinal,MesFinal,AnoFinal,HFinal,MFinal), [], ListaEntregasData),
		       converteListaEntregasToListaEncomendas(ListaEntregasData,[],ListaEncomendasEntregues),
		       getAllEncomendas(LEncomendas),
		       getEncomendasNaoEntregues(LEncomendas,ListaEncomendasEntregues,[],ListaEncomendasNaoEntregues),nl,	       
		       write('\u001b[35m[Lista de encomendas entregues]\u001b[0m -----------------'),nl,
		       printList(ListaEncomendasEntregues),nl,
		       write('\u001b[35m[Lista de encomendas não entregues]\u001b[0m -------------'),nl,
		       printList(ListaEncomendasNaoEntregues),
		       write('----------------------------------------------'),nl,!.
executa(X) :- X =:= 10, nl,write('Insira ID Estafeta :'),nl,
						read(IDestafeta),nl,
						write('Insira dia-mes-ano)  :'),nl,
						read(Dia-Mes-Ano),nl,
						pesoTotalNumDia(IDestafeta,data(Dia,Mes,Ano,0,0),Resultado),nl,
						write('Peso total: '),write(Resultado),nl,
						write('----------------------------------------------'),nl,!.
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
filtraEntregasData([entrega(Id,IdEstafeta,IdEncomenda,Data,Encomenda)],DataInicial,DataFinal,ListEncomendas,NListEncomendas) :- 
						comparaData(Data,DataInicial,DataFinal),
					        adicionarElemLista(entrega(Id,IdEstafeta,IdEncomenda,Data,Encomenda),ListEncomendas,NListEncomendas),!.
filtraEntregasData([entrega(_,_,_,_,_)],_,_,ListEncomendas,ListEncomendas).	
filtraEntregasData([entrega(Id,IdEstafeta,IdEncomenda,Data,Encomenda)|XS],DataInicial,DataFinal,ListEncomendas,N2ListEncomendas) :- 
						comparaData(Data,DataInicial,DataFinal),
						adicionarElemLista(entrega(Id,IdEstafeta,IdEncomenda,Data,Encomenda),ListEncomendas,NListEncomendas),
					        filtraEntregasData(XS,DataInicial,DataFinal,NListEncomendas,N2ListEncomendas).
filtraEntregasData([entrega(_,_,_,_,_)|XS],DataInicial,DataFinal,ListEncomendas,NListEncomendas) :-
					       filtraEntregasData(XS,DataInicial,DataFinal,ListEncomendas,NListEncomendas).  								    
%Verifica se uma dada data está entre outras duas (data(Dia,Mes,Ano,Hora,Minuto) -> data(Dia,Mes,Ano,Hora,Minuto) -> data(Dia,Mes,Ano,Hora,Minuto) -> {V,F})
%comparaData(data(Dia,_,_,_,_),_,_) :- Dia =< 0, !,fail.
%comparaData(data(Dia,_,__,_),_,_) :- Dia > 31, !,fail.
%comparaData(_,data(DiaInicial,_,_,_,_),_) :- DiaInicial =< 0, !,fail.
%comparaData(_,data(DiaInicial,_,_,_,_),_) :- DiaInicial > 31, !,fail.
%comparaData(_,_,data(DiaFinal,_,_,_,_)) :- DiaFinal =< 0, !,fail.
%comparaData(_,_,data(DiaFinal,_,_,_,_)) :- DiaFinal > 31, !,fail.
%comparaData(data(_,Mes,_,_,_),_,_) :- Mes =< 0, !,fail.
%comparaData(data(_,Mes,_,_,_),_,_) :- Mes > 12, !,fail.
%comparaData(_,data(_,MesInicial,_,_,_),_) :- MesInicial =< 0, !,fail.
%comparaData(_,data(_,MesInicial,_,_,_),_) :- MesInicial > 12, !,fail.
%comparaData(_,_,data(_,MesFinal,_,_,_)) :- MesFinal =< 0, !,fail.
%comparaData(_,_,data(_,MesFinal,_,_,_)) :- MesFinal > 12, !,fail. 
comparaData(data(_,_,Ano,_,_),data(_,_,AnoInicial,_,_),data(_,_,_,_,_)) :- Ano < AnoInicial,!,fail.
comparaData(data(_,_,Ano,_,_),data(_,_,_,_,_),data(_,_,AnoFinal,_,_)) :- Ano > AnoFinal,!,fail.
comparaData(data(_,Mes,_,_,_),data(_,MesInicial,_,_,_),data(_,_,_,_,_)) :- Mes < MesInicial,!,fail.
comparaData(data(_,Mes,_,_,_),data(_,_,_,_,_),data(_,MesFinal,_,_,_)) :- Mes > MesFinal,!,fail.
comparaData(data(Dia,_,_,_,_),data(DiaInicial,_,_,_,_),data(_,_,_,_,_)) :- Dia < DiaInicial,!,fail.
comparaData(data(Dia,_,_,_,_),data(_,_,_,_,_),data(DiaFinal,_,_,_,_)) :- Dia > DiaFinal,!,fail.
comparaData(data(Dia,_,_,Hora,_),data(_,_,_,HoraInicial,_),data(DiaFinal,_,_,_,_)) :- Dia =:= DiaFinal, Hora < HoraInicial,!,fail.
comparaData(data(Dia,_,_,Hora,_),data(_,_,_,_,_),data(DiaFinal,_,_,HoraFinal,_)) :- Dia =:= DiaFinal, Hora > HoraFinal,!,fail.
comparaData(data(_,_,_,Hora,Minuto),data(_,_,_,_,MinutoInicial),data(_,_,_,HoraFinal,_)) :- Hora =:= HoraFinal, Minuto < MinutoInicial,!,fail.
comparaData(data(_,_,_,Hora,Minuto),data(_,_,_,_,_),data(_,_,_,HoraFinal,MinutoFinal)) :-  Hora =:= HoraFinal, Minuto > MinutoFinal,!,fail.
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

getAllEstafetas(X) :- findall(estafeta(ID,Nome,Encomendas),estafeta(ID,Nome,Encomendas),X).

getEntregaPorId(Id,X) :- findall(entrega(Id,IdEstafeta,IdEncomenda,Data,Avaliacao),entrega(Id,IdEstafeta,IdEncomenda,Data,Avaliacao),X).

getEstafetaPorID(ID,X) :-  findall(estafeta(ID,Nome,Encomendas),estafeta(ID,Nome,Encomendas),[X|_]).

getAllEntregas(X) :- findall(entrega(Id,IdEstafeta,IdEncomenda,Data,Avaliacao),entrega(Id,IdEstafeta,IdEncomenda,Data,Avaliacao),X).

getAllIdEntregas(X) :- findall(Id,entrega(Id,_,_,_,_),X).

getAllIdEncomendasEntregas(X) :- findall(IdEncomenda,entrega(_,_,IdEncomenda,_,_),X).

getAllEncomendas(X) :- findall(encomenda(Id, Peso, Volume, Cliente, Prazo,Rua,Transporte, Preco,Data),
			   encomenda(Id, Peso, Volume, Cliente, Prazo,Rua,Transporte, Preco,Data),X).
			   
getAllIdEncomendas(X) :- findall(Id,encomenda(Id, _, _, _, _,_,_, _,_),X).

% 1.Identificar estafeta que utilizou mais vezes um meio de transporte mais ecológico --------------------------------------------------------------------------

nomeESt([],[]).
nomeESt([H|T],L):-findall((H,Nome),estafeta(H,Nome,_),[S|_]),
                  nomeESt(T,Z),
               L = [S|Z].

estMaisEco(Max,IdNomes):- findall((IdStaff,Lenc),estafeta(IdStaff,_,Lenc),L),
                       sort(0,@<,L,Ls),
                       estAux(Max,Ls,IdMaxL),
                   nomeESt(IdMaxL,IdNomes).

estAux(0,[],[]).
estAux(Max,[(IdEst,Lenc)],[IdEst]):- estCount(Lenc,C),
                              Max = C.
estAux(Max,[(IdEst,Lenc)|T],L):- estCount(Lenc,Count),
                       estAux(CountMax,T,Ls),
                        (Count > CountMax -> Max = Count, L = [IdEst];
                         Count == CountMax -> Max = CountMax, L = [IdEst|Ls]; Max = CountMax, L = Ls).

estCount([Idenc|T],X):- findall(Trans,encomenda(Idenc,_,_,_,_,_,Trans,_,_),L),
                              soma(L,X).
soma([],0).
soma([H|T],S):-soma(T,G),S is H+G.




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



% 4. Calcular o valor faturado pela Green Distribution num determinado dia--------------------------------------------------------------------------


calculaF(data(D,M,A,Ho,Min),Vfaturado):- findall(IdEncomenda,(entrega(_,_,IdEncomenda,data(D,M,A,_,_),_), D=:=D,M=:=M,A=:=A),X),
			   calculaFaturacao(X,SomaPreco),
			   Vfaturado is SomaPreco.

calculaFaturacao([],0).
calculaFaturacao([IdEncomenda],Preco) :- getEncomendaPorId(IdEncomenda,encomenda(_,_,_,_,_,_,_,Preco,_)).
calculaFaturacao([IdEncomenda|XS],N2) :- getEncomendaPorId(IdEncomenda,encomenda(_,_,_,_,_,_,_,Preco,_)),
						       calculaFaturacao(XS,N),
						       N2 is N + Avaliacao.



% 6.Calcular a classificação média de satisfação dos cliente para um determinado estafeta -----------------------------------------------------------------------

calculaRankingEstafetaPorCliente(NomeEstafeta,Ranking) :- getEstafetaPorNome(NomeEstafeta,estafeta(_,_,ListaEncomendas)),
							  calculaRanking(ListaEncomendas,SomaRanking,NumeroDeAval),
							  Ranking is SomaRanking / NumeroDeAval.

						  
% Transforma lista de clientes em lista de Id Encomendas ([Cliente] -> [Lista de Id Encomendas Inicial ([])] -> [IdEncomendas])
encomendasCliente([],[],[]).
encomendasCliente([cliente(_,_,_,IdEncomenda)],ListaEncomendas,NListaEncomendas) :- adicionarElemLista(IdEncomenda,ListaEncomendas,NListaEncomendas).
encomendasCliente([cliente(_,_,_,IdEncomenda)|XS],ListaEncomendas,N2ListaEncomendas) :- adicionarElemLista(IdEncomenda,ListaEncomendas,NListaEncomendas),
										      encomendasCliente(XS,NListaEncomendas,N2ListaEncomendas).

% Calcular o ranking ([Id Encomenda] -> Soma dos Rankings -> Número de Ranking)
calculaRanking([],0,0).
calculaRanking([IdEncomenda],Avaliacao,1) :- getEntregaPorIdEncomenda(IdEncomenda,entrega(_,_,_,_,Avaliacao)).
calculaRanking([IdEncomenda|XS],N2,C2) :- getEntregaPorIdEncomenda(IdEncomenda,entrega(_,_,_,_,Avaliacao)), 
						       calculaRanking(XS,N,C),
						       N2 is N + Avaliacao,
						       C2 is C+1.

% 7. Número total de entregas pelos diferentes meios de transporte num intervalo de tempo--------------------------------------------------------------
comp(Si,(D,M,A,H,Min),Sf) :- date_time_stamp(date(A,M,D,H,Min,0,0,-,-),S),
                          (S >= Si -> true; false).
comp(Si,(D,M,A,H,Min),Sf) :- date_time_stamp(date(A,M,D,H,Min,0,0,-,-),S),
                          (S =< Sf -> true; false).

filtra(Si,Sf,Lent) :- findall((Id,IdEs,IdEnc,data(D,M,A,H,Min),Av),(entrega(Id,IdEs,IdEnc,data(D,M,A,H,Min),Av), comp(Si,(D,M,A,H,Min),Sf)),Lent).
                                      
listaEnc([],[]).
listaEnc([(_,_,ID,_,_)],L) :- findall((ID,Peso,Vol,Cli,Prazo,Rua,Tra,Pre,D),(encomenda(ID,Peso,Vol,Cli,Prazo,Rua,Tra,Pre,D), ID =:= ID),L).
listaEnc([(_,_,ID,_,_)|T],L) :- findall((ID,Peso,Vol,Cli,Prazo,Rua,Tra,Pre,D),(encomenda(ID,Peso,Vol,Cli,Prazo,Rua,Tra,Pre,D), ID =:= ID),[S|_]), 
                                listaEnc(T,Z), 
                                L = [S|Z].

      
bic((ID,Peso,Vol,Cli,Prazo,Rua,Tran,Pre,D)) :- Tran =:= 1. 
            
listaEB(Le,L) :- include(bic,Le,L).

moto((ID,Peso,Vol,Cli,Prazo,Rua,Tran,Pre,D)) :- Tran =:= 2.   
          
listaEM(Le,L) :- include(moto,Le,L).

carro((ID,Peso,Vol,Cli,Prazo,Rua,Tran,Pre,D)) :- Tran =:= 3.  
           
listaEC(Le,L) :- include(carro,Le,L).

% 8. Identificar  o  número  total  de  entregas  pelos  estafetas,  num  determinado intervalo de tempo

numeroEntregasEstafeta([], DataInicio, DataFim, 0).

numeroEntregasEstafeta([estafeta(_,_,Encomendas)], DataInicio, DataFim, N) :- getAllIdEntregas(LIdentregas),
                                    verificaEntregas(Encomendas,LIdentregas, [], LEntregues),
                                    converteListaIdToEntregas(LEntregues,[],LEntregas),
                                    filtraEntregasData(LEntregas,DataInicio,DataFim,[],ListaEntregas),
                                    length(ListaEntregas, N).

numeroEntregasEstafeta([estafeta(_,_,Encomendas)|XS], DataInicio, DataFim, N2) :- 
                                    getAllIdEntregas(LIdentregas),
                                    verificaEntregas(Encomendas,LIdentregas,[], LEntregues),
                                    converteListaIdToEntregas(LEntregues,[],LEntregas),
                                    filtraEntregasData(LEntregas,DataInicio,DataFim,[],ListaEntregas),
                                    numeroEntregasEstafeta(XS, DataInicio, DataFim, N),
                                    length(ListaEntregas, X),
                                    N2 is N + X.

verificaEntregas([Id],LIdentregas,Lista, LEntregues) :-  member(Id,LIdentregas),
                            adicionarElemLista(Id,Lista,LEntregues),!.
verificaEntregas([Id],LIdentregas,Lista, Lista).
verificaEntregas([Id|LE],LIdentregas,Lista, LEntregues2) :- member(Id,LIdentregas),
                            adicionarElemLista(Id,Lista,LEntregues),
                        verificaEntregas(LE,LIdentregas,LEntregues,LEntregues2).

verificaEntregas([Id|LE],LIdentregas,Lista, LEntregues) :- 
                        verificaEntregas(LE,LIdentregas,Lista,LEntregues).


converteListaIdToEntregas([],[],[]).
converteListaIdToEntregas([Id], LEntregas, LEntregas2) :- getEntregaPorId(Id,[Entrega]),
                            adicionarElemLista(Entrega,LEntregas,LEntregas2).
converteListaIdToEntregas([Id|LId], LEntregas, LEntregas2) :- getEntregaPorId(Id,[Entrega]),
                            adicionarElemLista(Entrega,LEntregas,LEntregas3),
                            converteListaIdToEntregas(LId,LEntregas3,LEntregas2).

% 9. Calcular o número de encomendas entregues e não entregues([Encomenda] -> [Entregas] -> [] -> [] -> [Encomendas Não Entregues] -> [Encomendas Entregues] ) -

converteListaEntregasToListaEncomendas([],[],[]).
converteListaEntregasToListaEncomendas([entrega(_,_,IdEncomenda,_,_)],ListaEncomendas,NListaEncomendas) :- getEncomendaPorId(IdEncomenda,Encomenda),
										    adicionarElemLista(Encomenda,ListaEncomendas,NListaEncomendas).
converteListaEntregasToListaEncomendas([entrega(_,_,IdEncomenda,_,_)|XS],ListaEncomendas,N2ListaEncomendas) :- getEncomendaPorId(IdEncomenda,Encomenda),
								    adicionarElemLista(Encomenda,ListaEncomendas,NListaEncomendas),
								    converteListaEntregasToListaEncomendas(XS,NListaEncomendas,N2ListaEncomendas).
	
getEncomendasNaoEntregues([],[],[],[]).	
getEncomendasNaoEntregues([X],ListaEncomendasEntregues,ListaEncomendasNaoEntregues,NListaEncomendasNaoEntregues) :- 
						not(member(X,ListaEncomendasEntregues)),
						adicionarElemLista(X,ListaEncomendasNaoEntregues,NListaEncomendasNaoEntregues),!.
getEncomendasNaoEntregues([_],_,ListaEncomendasNaoEntregues,NListaEncomendasNaoEntregues) :- 
						NListaEncomendasNaoEntregues is ListaEncomendasNaoEntregues,!.					    
getEncomendasNaoEntregues([X|XS],ListaEncomendasEntregues,ListaEncomendasNaoEntregues,N2ListaEncomendasNaoEntregues) :- 
						not(member(X,ListaEncomendasEntregues)),
		              			adicionarElemLista(X,ListaEncomendasNaoEntregues,NListaEncomendasNaoEntregues),
		              			getEncomendasNaoEntregues(XS,ListaEncomendasEntregues,NListaEncomendasNaoEntregues,N2ListaEncomendasNaoEntregues).
getEncomendasNaoEntregues([_|XS],ListaEncomendasEntregues,ListaEncomendasNaoEntregues,N2ListaEncomendasNaoEntregues) :- 
		              			getEncomendasNaoEntregues(XS,ListaEncomendasEntregues,ListaEncomendasNaoEntregues,N2ListaEncomendasNaoEntregues). 
					 					
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

