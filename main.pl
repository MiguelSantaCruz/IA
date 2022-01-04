%#!/usr/bin/env swipl
%:- initialization(main, main).


%carregar a base de conhecimento atual
:- consult('baseDeConhecimento.pl').
:- consult('invariantes.pl').

%Loop principal que implementa o menu de interação com a aplicação
%Nota:\u001b[32m é o código de cor para verde, \u001b[34m é o código de cor para vermelho e \u001b[0m é o código de reset de cor
%As cores só funcionam em terminais unix
main :- write('\033[H\033[2J'),
	repeat,
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
	write('\u001b[34m[11]\u001b[0m Adicionar termo à base de conhecimento'),nl,
	write('\u001b[34m[12]\u001b[0m Encontrar caminho até ao nodo (Heurística A*)'),nl,
	write('\u001b[34m[13]\u001b[0m Encontrar caminho até ao nodo (Greddy search)'),nl,
	write('\u001b[34m[14]\u001b[0m Encontrar caminho até ao nodo (DFS)'),nl,
	write('\u001b[34m[15]\u001b[0m Encontrar caminho até ao nodo (BFS)'),nl,
	write('\u001b[34m[16]\u001b[0m Encontrar caminho até ao nodo (DFS com profundidade limitada)'),nl,
	write('\u001b[34m[17]\u001b[0m Escolher o meio de transporte mais ecológico'),nl,
	write('\u001b[34m[18]\u001b[0m Sair'),nl,
	nl,
	write('Insira escolha: '),nl,
	read(Escolha),
	validaEscolha(Escolha),
	executa(Escolha),
  	nl,nl,fail.
 
%Função que valida as escolhas feitas( se estão entre 1 e 17)  
validaEscolha(X) :- X =< 0,write('\u001b[31mEscolha inválida\u001b[0m'),nl,!,fail.
validaEscolha(X) :- X > 17,write('\u001b[31mEscolha inválida\u001b[0m'),nl,!,fail.
validaEscolha(_).

%Função que chama as funções que implementam as funcionalidades
executa(X) :- X =:= 1, estMaisEco(_,Nome),
			printList(Nome),nl,!.
executa(X) :- X =:= 2, write('Insira ID Cliente'),nl,
			   read(Id),
			   identificaEstafetaByCliente(Id,Estafetas),nl,
			   write('Estafetas : '),nl,
			   printList(Estafetas),nl,
			   write('----------------------------------------------'),nl,!.
executa(X) :- X =:= 3, write('Insira Nome Estafeta: '),nl,
		       read(Nome),
		       identificaClientesByEstafeta(Nome,L),nl,
		       write('\u001b[35m[Lista de Clientes associados]\u001b[0m ------------------'),nl,
		       write('Identificador - Nome - NIF - Encomenda'),nl,
		       printList(L),write('--------------------------------------------------'),!.
executa(X) :- X =:= 4, write('Insira data (dd-mm-aaaa) :'),nl,
		        read(Dia-Mes-Ano),nl,
		        calculaF(data(Dia,Mes,Ano,0,0),V),
		        write(V),nl,!. 
executa(X) :- X =:= 5, getAllEntregas(LEntregas),
            converteEntregasToEncomendas(LEntregas, [], LEncomendas),
            convertEncomendasToRuas(LEncomendas, [], LRuas),
            getAllIdRuas(LIdRuas),
            contarRuas(LIdRuas, LRuas, [], Lista),
            ordenarLista(Lista, LOrd),
            zonasMaximo(LOrd, 0, [], Zonas),
            converteIdToRuas(Zonas, [], ListaFinal),
            printList(ListaFinal),
            write('----------------------------------------------'),nl,!. 
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
		       listaEB(LE,Lb,Tam),
		       write("Número de entregas realizadas de bicicleta:"),write(Tam),nl,
		       printList(Lb),nl,
		       listaEM(LE,LM,TamM),
		       write("Número de entregas realizadas de moto:"),write(TamM),nl,
		       printList(LM),nl,
		       listaEC(LE,LC,TamC),
		       write("Número de entregas realizadas de carro:"),write(TamC),nl,	      
		       printList(LC),nl,
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
		       date_time_stamp(date(AnoInicial,MesInicial,DiaInicial,HInicial,MInicial,0,0,-,-), Si),
		       date_time_stamp(date(AnoFinal,MesFinal,DiaFinal,HFinal,MFinal,0,0,-,-), Sf),
		       filtraEntregas(Si,Sf,ListaEntregasData),
		       converteListaEntregasToListaEncomendas(ListaEntregasData,[],ListaEncomendasEntregues),
		       filtraEncomendas(Si,Sf,LEncomendasData),
		       getEncomendasNaoEntregues(LEncomendasData,ListaEncomendasEntregues,[],ListaEncomendasNaoEntregues),nl,	       
		       write('\u001b[35m[Lista de encomendas entregues]\u001b[0m -----------------'),nl,
		       printList(ListaEncomendasEntregues),nl,
		       write('\u001b[35m[Lista de encomendas não entregues]\u001b[0m -------------'),nl,
		       printList(ListaEncomendasNaoEntregues),
		       write('----------------------------------------------'),nl,!.
executa(X) :- X =:= 10, nl,write('Insira ID Estafeta :'),nl,
						read(IDestafeta),nl,
						write('Insira dia-mes-ano  :'),nl,
						read(Dia-Mes-Ano),nl,
						pesoTotalNumDia(IDestafeta,data(Dia,Mes,Ano,0,0),Resultado),nl,
						write('Peso total: '),write(Resultado),nl,
						write('----------------------------------------------'),nl,!.
executa(X) :- X =:= 11, nl,write('Termos disponíveis para adicionar:'),nl,
			   write('• estafeta(ID, Nome, Lista de Encomendas)'),nl,
			   write('• entrega(ID, ID do Estafeta,ID da Encomenda, Data, Encomenda)'),nl,
			   write('• encomenda(ID, Peso, Volume, ID do Cliente, Prazo em horas, ID da Rua, ID do Transporte, Preço, data(dd,mm,aaaa,hh,mm))'),nl,
			   write('• rua(ID, Nome, Distância ao centro em Kms)'),nl,
			   write('• estrada(ID, ID da rua 1, ID da rua 2, Comprimento)'),nl,nl,
			   write('Insira Termo a adicionar :'),nl,
			   read(Termo),nl,
			   evolucao(Termo),nl,!.
executa(X) :- X =:= 12, nl,write('Insira o ID da rua atual'),nl,
						read(Nodo),nl,
						resolve_aestrela(Nodo,Cam/C),
						nomeRua(Cam,Ruas),
						printList(Ruas),nl,write('Custo: '),write(C),nl,!.
executa(X) :- X =:= 13, nl, write('Insira ID Estafeta : '),nl,
                            read(IDestafeta),nl,
			     getRuaPorEstafeta(IDestafeta,Idrua),
			     resolve_gulosa(Idrua,Caminho/_),
			     inverso(Caminho,Cinv),
			     nomeRua(Cinv,CN),
			     printList(CN),nl,!.
executa(X) :- X =:= 14, nl,write('Insira o ID da rua atual'),nl,
						read(Nodo),nl,
						dfs(Nodo,L,C),
						nomeRua(L,Ruas),
						printList(Ruas),nl,write('Custo: '),write(C),nl,!.
executa(X) :- X =:= 15, nl,write('Não implementada'),nl,!.
executa(X) :- X =:= 16, nl,write('Não implementada'),nl,!.
executa(X) :- X =:= 17, halt.


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


filtraEntregas(Si,Sf,Lent) :- findall(entrega(Id,IdEs,IdEnc,data(D,M,A,H,Min),Av),(entrega(Id,IdEs,IdEnc,data(D,M,A,H,Min),Av), comp(Si,(D,M,A,H,Min),Sf)),Lent).
filtraEncomendas(Si,Sf,Lent) :- findall(encomenda(Id,Peso,Vol,IdCliente,Prazo,Rua,Trans,Preco,data(D,M,A,H,Min)),(encomenda(Id,Peso,Vol,IdCliente,Prazo,Rua,Trans,Preco,data(D,M,A,H,Min)), comp(Si,(D,M,A,H,Min),Sf)),Lent).

%Filtra entregas por data ([Entrega] -> data(Dia,Mes,Ano) -> data(Dia,Mes,Ano) -> [] -> [Entregas])
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
%Filtra encomenda por data ([Encomendas] -> data(Dia,Mes,Ano) -> data(Dia,Mes,Ano) -> [] -> [Encomedas])
filtraEncomendasData([],_,[],[]).
filtraEncomendasData([encomenda(Id, Peso, Volume, Cliente, Prazo,Rua,Transporte, Preco,Data)],DataInicial,ListEncomendas,NListEncomendas) :- 
						dataAnterior(Data,DataInicial),
					        adicionarElemLista(encomenda(Id, Peso, Volume, Cliente, Prazo,Rua,Transporte, Preco,Data),ListEncomendas,NListEncomendas),!.
filtraEncomendasData([_],_,ListEncomendas,ListEncomendas).	
filtraEncomendasData([encomenda(Id, Peso, Volume, Cliente, Prazo,Rua,Transporte, Preco,Data)|XS],DataInicial,ListEncomendas,N2ListEncomendas) :- 
						dataAnterior(Data,DataInicial),
						adicionarElemLista(encomenda(Id, Peso, Volume, Cliente, Prazo,Rua,Transporte, Preco,Data),ListEncomendas,NListEncomendas),
					        filtraEncomendasData(XS,DataInicial,NListEncomendas,N2ListEncomendas).
filtraEncomendasData([_|XS],DataInicial,ListEncomendas,NListEncomendas) :-
					       	filtraEncomendasData(XS,DataInicial,ListEncomendas,NListEncomendas).
					       	
					       	
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

%Diz se uma data é anterior a outra
dataAnterior(data(_,_,Ano,_,_),data(_,_,AnoFinal,_,_)) :- Ano > AnoFinal,!,fail.
dataAnterior(data(_,Mes,_,_,_),data(_,MesFinal,_,_,_)) :- Mes > MesFinal,!,fail.
dataAnterior(data(Dia,_,_,_,_),data(DiaFinal,_,_,_,_)) :- Dia > DiaFinal,!,fail.
dataAnterior(data(Dia,_,_,Hora,_),data(DiaFinal,_,_,HoraFinal,_)) :- Dia =:= DiaFinal, Hora > HoraFinal,!,fail.
dataAnterior(data(_,_,_,Hora,Minuto),data(_,_,_,HoraFinal,MinutoFinal)) :- Hora =:= HoraFinal,Minuto > MinutoFinal,!,fail.
dataAnterior(_,_).

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

getEstafetaPorID(ID,X) :-  findall(Nome,estafeta(ID,Nome,_),[X|_]).

getAllEntregas(X) :- findall(entrega(Id,IdEstafeta,IdEncomenda,Data,Avaliacao),entrega(Id,IdEstafeta,IdEncomenda,Data,Avaliacao),X).

getAllIdEntregas(X) :- findall(Id,entrega(Id,_,_,_,_),X).

getAllIdEncomendasEntregas(X) :- findall(IdEncomenda,entrega(_,_,IdEncomenda,_,_),X).

getAllEncomendas(X) :- findall(encomenda(Id, Peso, Volume, Cliente, Prazo,Rua,Transporte, Preco,Data),
			   encomenda(Id, Peso, Volume, Cliente, Prazo,Rua,Transporte, Preco,Data),X).
			   
getAllIdEncomendas(X) :- findall(Id,encomenda(Id, _, _, _, _,_,_, _,_),X).

getAllRuas(X) :- findall(rua(Id,Nome,Freguesia,Distancia),rua(Id,Nome,Freguesia,Distancia),X).

getAllIdRuas(X) :- findall(Id,rua(Id,_Nome,_Freguesia,_Distancia),X).

getRuaPorId(Id,X) :- findall(rua(Id,Nome,Freguesia,Distancia),rua(Id,Nome,Freguesia,Distancia),X). 

% 1.Identificar estafeta que utilizou mais vezes um meio de transporte mais ecológico --------------------------------------------------------------------------

nomeESt([],[]).
nomeESt([H|T],L):-findall(Nome,estafeta(H,Nome,_),[S|_]),
                  nomeESt(T,Z),
               L = [S|Z].

estMaisEco(Max,IdNomes):- findall((IdEst,Lenc),estafeta(IdEst,_,Lenc),L),
                       sort(0,@<,L,Ls),
                       estAux(Max,Ls,IdMaxL),
                   nomeESt(IdMaxL,IdNomes).

estAux(0,[],[]).
estAux(Max,[(IdEst,Lenc)],[IdEst]):- estCount(Lenc,C),
                              Max = C.
estAux(Max,[(IdEst,Lenc)|T],L):- estCount(Lenc,Count),
                       estAux(CountMax,T,Ls),
                        (Count < CountMax -> Max = Count, L = [IdEst];
                         Count == CountMax -> Max = CountMax, L = [IdEst|Ls]; Max = CountMax, L = Ls).

estCount([Idenc|_],X):- findall(Trans,(encomenda(Idenc,_,_,_,_,_,Trans,_,_), Idenc=:=Idenc),L),
                              media(L,X).
soma([],0).
soma([H|T],S):-soma(T,G),S is H+G.


media(L,M):- soma(L, S), length(L,T), M is S / T.



% 2. identificar que estafetas entregaram determinada(s) encomenda(s) a um determinado cliente; (id Cliente-> [Entregas] -> idEstafeta -> NomeEstafeta)--------------------------------------------------------------------------

identificaEstafetaByCliente(IdCliente,ListaEstafetas) :- listaIdEncomendasPorCliente(IdCliente,ListaIdEncomendas),
							listaIdsEncomendasParaListaIdEstafetas(ListaIdEncomendas,[],ListaIdEstafetas),
							listaEstafetasbyListaIdEstafetas(ListaIdEstafetas,[],ListaEstafetas).

listaIdEncomendasPorCliente(IdCliente,ListaIdsEncomendas) :- findall(Id, encomenda(Id,_,_,IdCliente,_,_,_,_,_),ListaIdsEncomendas).

listaIdsEncomendasParaListaIdEstafetas([],[],[]).
listaIdsEncomendasParaListaIdEstafetas([IdEncomenda],ListaIdEstafetas,NListaIdEstafetas):- findall(IdEstafeta,entrega(_,IdEstafeta,IdEncomenda,_,_),ListaRIdEstafetas),
											append(ListaRIdEstafetas,ListaIdEstafetas,NListaIdEstafetas).
listaIdsEncomendasParaListaIdEstafetas([IdEncomenda|T],ListaIdEstafetas,NListaIdEstafetas):- listaIdsEncomendasParaListaIdEstafetas([IdEncomenda],ListaIdEstafetas,N2ListaIdEstafetas),
											listaIdsEncomendasParaListaIdEstafetas(T,ListaIdEstafetas,N3ListaIdEstafetas),
											append(N2ListaIdEstafetas,N3ListaIdEstafetas,NListaIdEstafetas).

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


calculaF(data(D,M,A,_,_),Vfaturado):- findall(IdEncomenda,(entrega(_,_,IdEncomenda,data(D,M,A,_,_),_), D=:=D,M=:=M,A=:=A),X),
			   calculaFaturacao(X,SomaPreco),
			   Vfaturado is SomaPreco.

calculaFaturacao([],0).
calculaFaturacao([IdEncomenda],Preco) :- getEncomendaPorId(IdEncomenda,encomenda(_,_,_,_,_,_,_,Preco,_)).
calculaFaturacao([IdEncomenda|XS],N2) :- getEncomendaPorId(IdEncomenda,encomenda(_,_,_,_,_,_,_,Preco,_)),
						       calculaFaturacao(XS,N),
						       N2 is N + Preco.


% 5. Identificar  quais  as  zonas  (e.g.,  rua  ou  freguesia)  com  maior  volume  de entregas por parte da Green Distribution 

converteEntregasToEncomendas([entrega(_,_,Enc,_,_)], LEncomenda, LEncomenda2) :- getEncomendaPorId(Enc,Encomenda),
                                              adicionarElemLista(Encomenda,LEncomenda, LEncomenda2).
converteEntregasToEncomendas([entrega(_,_,Enc,_,_)|LE], LEncomenda, LEncomenda2) :- getEncomendaPorId(Enc,Encomenda),
                                              adicionarElemLista(Encomenda,LEncomenda, LEncomenda3),
                                            converteEntregasToEncomendas(LE,LEncomenda3,LEncomenda2).


convertEncomendasToRuas([encomenda(_,_,_,_,_,Rua,_,_,_)], LRuas, LRuas2) :- adicionarElemLista(Rua,LRuas, LRuas2).
convertEncomendasToRuas([encomenda(_,_,_,_,_,Rua,_,_,_)|LE], LRuas, LRuas2) :- adicionarElemLista(Rua,LRuas, LRuas3),
                                            convertEncomendasToRuas(LE, LRuas3, LRuas2).

contarRuas([Rua], LIdRuas, L, Lista) :- count(Rua, LIdRuas, N),
                        adicionarElemLista((N, Rua), L, Lista).

contarRuas([Rua|LRuas], LIdRuas, L, Lista) :- count(Rua, LIdRuas, N),
                        adicionarElemLista((N, Rua), L, L2),
                        contarRuas(LRuas, LIdRuas, L2, Lista).


ordenarLista(L, Lord) :- sort(1,@>,L,Lord).

zonasMaximo([], 0, [],[]).

zonasMaximo([(N, Rua)], Max, ListaAux,Lista2) :- N>=Max -> adicionarElemLista(Rua,ListaAux,Lista2).
zonasMaximo([(_,_)], _, _,_).
zonasMaximo([(N, Rua)|LR], Max, ListaAux,Lista2) :- zonasMaximo(LR, N, ListaAux, Lista1),
                               N>=Max -> adicionarElemLista(Rua,Lista1,Lista2).
zonasMaximo([(_, _)|_], _, _,_). 

count(_, [], 0).
count(X, [X | T], N) :-
  !, count(X, T, N1),
  N is N1 + 1.
count(X, [_ | T], N) :-
  count(X, T, N).

converteIdToRuas([Id], LAux, LRuas) :- getRuaPorId(Id, Rua),
                       adicionarElemLista(Rua, LAux, LRuas).

converteIdToRuas([Id|LId], LAux, LRuas) :- getRuaPorId(Id, Rua),
                       adicionarElemLista(Rua, LAux, L2),
                        converteIdToRuas(LId, L2, LRuas). 


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

comp(Si,(D,M,A,H,Min),Sf) :- date_time_stamp(date(A,M,D,H,Min,0,0,-,-),S), S =< Sf, S >= Si.



filtra(Si,Sf,Lent) :- findall(IdEnc,(entrega(_,_,IdEnc,data(D,M,A,H,Min),_), comp(Si,(D,M,A,H,Min),Sf)),Lent).
                                      
listaEnc([],[]).
listaEnc([ID],L) :- findall((ID,Peso,Vol,Cli,Prazo,Rua,Tra,Pre,D),(encomenda(ID,Peso,Vol,Cli,Prazo,Rua,Tra,Pre,D), ID =:= ID),L).
listaEnc([ID|T],L) :- findall((ID,Peso,Vol,Cli,Prazo,Rua,Tra,Pre,D),(encomenda(ID,Peso,Vol,Cli,Prazo,Rua,Tra,Pre,D), ID =:= ID),[S|_]), 
                                listaEnc(T,Z), 
                                L = [S|Z].

      
bic((_,_,_,_,_,_,Tran,_,_)) :- Tran =:= 1. 
            
listaEB(Le,L,Tam) :- include(bic,Le,L), length(L,Tam).

moto((_,_,_,_,_,_,Tran,_,_)) :- Tran =:= 2.   
          
listaEM(Le,L,Tam) :- include(moto,Le,L), length(L,Tam).

carro((_,_,_,_,_,_,Tran,_,_)) :- Tran =:= 3.  
           
listaEC(Le,L,Tam) :- include(carro,Le,L), length(L,Tam).

% 8. Identificar  o  número  total  de  entregas  pelos  estafetas,  num  determinado intervalo de tempo

numeroEntregasEstafeta([],_,_, 0).

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
verificaEntregas([_],_,_, _).
verificaEntregas([Id|LE],LIdentregas,Lista, LEntregues2) :- member(Id,LIdentregas),
                            adicionarElemLista(Id,Lista,LEntregues),
                        verificaEntregas(LE,LIdentregas,LEntregues,LEntregues2).

verificaEntregas([_|LE],LIdentregas,Lista, LEntregues) :- 
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
getEncomendasNaoEntregues([_],_,ListaEncomendasNaoEntregues,ListaEncomendasNaoEntregues).				    
getEncomendasNaoEntregues([X|XS],ListaEncomendasEntregues,ListaEncomendasNaoEntregues,N2ListaEncomendasNaoEntregues) :- 
						not(member(X,ListaEncomendasEntregues)),
		              			adicionarElemLista(X,ListaEncomendasNaoEntregues,NListaEncomendasNaoEntregues),
		              			getEncomendasNaoEntregues(XS,ListaEncomendasEntregues,NListaEncomendasNaoEntregues,N2ListaEncomendasNaoEntregues).
getEncomendasNaoEntregues([_|XS],ListaEncomendasEntregues,ListaEncomendasNaoEntregues,N2ListaEncomendasNaoEntregues) :- 
		              			getEncomendasNaoEntregues(XS,ListaEncomendasEntregues,ListaEncomendasNaoEntregues,N2ListaEncomendasNaoEntregues). 
					 					
%---------------------------------------------------------------------------------------------------------------------------------------------------------------

%10 calcular o peso total transportado por estafeta num determinado dia

pesoTotalNumDia(IdEstafeta,Dia,Res):- listaIdsEncomendasNumDia(IdEstafeta,Dia,ListaIdEncomendas),
									  listaEncomendasParaPeso(ListaIdEncomendas,Res).


listaIdsEncomendasNumDia(Id,Data,Res) :- findall(Encomenda, (entrega(_,Id,Encomenda,D,_),dataSimples(D,Data)),Res).


listaEncomendasParaPeso([],0).
listaEncomendasParaPeso([H],PesoTotal):- encomenda(H,Peso,_,_,_,_,_,_,_),
									PesoTotal is Peso.
listaEncomendasParaPeso([H|T],PesoTotal):- listaEncomendasParaPeso([H],Peso1),
										   listaEncomendasParaPeso(T,Peso2),
										   PesoTotal is Peso1 + Peso2.
										
dataSimples(data(Dia,Mes,Ano,_,_),data(Dia2,Mes2,Ano2,_,_)) :- Dia == Dia2, Mes == Mes2 , Ano == Ano2.

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
getRuaPorEstafeta(IdEst,Idrua):- findall(IDenc,estafeta(IdEst,_,[IDenc|_]),[Idenc]),
					findall(Idenc,encomenda(Idenc, _, _, _, _,Idrua,_, _,_),[Idrua]).

nomeRua([],[]).
nomeRua([H|T],L):-findall(Nome,rua(H,Nome),[S|_]),
                  nomeRua(T,Z),
               L = [S|Z].


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
obtem_melhor_distancia_g([Caminho1/Custo1/Est1,_/Custo2/Est2|Caminhos], MelhorCaminho) :-
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
