:-set_prolog_flag(discontiguous_warnings,off).
:-set_prolog_flag(single_var_warnings,off).
:-set_prolog_flag(answer_write_options,[max_depth(0)]).




:- dynamic (transporte/5).
:- dynamic (rua/2).
:- dynamic (encomenda/9).
:- dynamic (cliente/4).
:- dynamic (estafeta/3).
:- dynamic (entrega/6).
:- dynamic (estrada/4).
:- dynamic (estima/2).


%BASE DO CONHECIMENTO

%-------------------Grafo----------------------
%estrada(idEstrada,idRua1,idRua2,distancia)
estrada(1,1,2,1).
estrada(2,1,5,1).
estrada(3,1,6,3).
estrada(4,1,11,5).
estrada(5,1,10,16).
estrada(6,2,3,4).
estrada(7,3,5,3).
estrada(8,4,5,4).
estrada(9,4,6,4).
estrada(10,6,11,9).
estrada(11,6,10,13).
estrada(12,7,8,3).
estrada(13,7,10,11).
estrada(14,7,11,8).
estrada(15,8,9,8).
estrada(16,8,11,11).
estrada(17,9,12,7).
estrada(18,10,12,8).

%----------Estima distâncias-----------
estima(1,1,0).
estima(1,2,3).
estima(1,3,5).
estima(1,4,6).
estima(1,5,1).
estima(1,6,3).
estima(1,7,15).
estima(1,8,16).
estima(1,9,29).
estima(1,10,16).
estima(1,11,5).
estima(1,12,14).

estima(2,2,0).
estima(2,3,5).
estima(2,4,6).
estima(2,5,2).
estima(2,6,3).
estima(2,7,25).
estima(2,8,26).
estima(2,9,29).
estima(2,10,26).
estima(2,11,5).
estima(2,12,24).

estima(3,3,0).
estima(3,4,6).
estima(3,5,3).
estima(3,6,3).
estima(3,7,35).
estima(3,8,36).
estima(3,9,39).
estima(3,10,36).
estima(3,11,5).
estima(3,12,34).

estima(4,4,0).
estima(4,5,4).
estima(4,6,4).
estima(4,7,45).
estima(4,8,46).
estima(4,9,49).
estima(4,10,46).
estima(4,11,5).
estima(4,12,44).

estima(5,5,0).
estima(5,6,5).
estima(5,7,55).
estima(5,8,56).
estima(5,9,59).
estima(5,10,56).
estima(5,11,5).
estima(5,12,55).

estima(6,6,0).
estima(6,7,55).
estima(6,8,56).
estima(6,9,59).
estima(6,10,56).
estima(6,11,5).
estima(6,12,55).

estima(7,7,0).
estima(7,8,56).
estima(7,9,59).
estima(7,10,56).
estima(7,11,5).
estima(7,12,55).

estima(8,8,0).
estima(8,9,59).
estima(8,10,56).
estima(8,11,5).
estima(8,12,55).

estima(9,9,0).
estima(9,10,56).
estima(9,11,5).
estima(9,12,55).

estima(10,10,0).
estima(10,11,5).
estima(10,12,55).

estima(11,11,0).
estima(11,12,55).

estima(12,12,0).
%-----------------Encomendas------------------
%encomenda(identificador, peso, volume, cliente, prazo de entrega(horas),rua, preço, Estado,data de encomenda)

encomenda(1,5,53,1,6,2,20,efetuada,data(5,12,2021,07,00)).
encomenda(2,13,20,2,12,3,30,efetuada,data(1,12,2021,01,00)).
encomenda(3,2,3,3,24,6,2022,efetuada,data(2,12,2021,19,00)).
encomenda(4,7,43,4,16,8,203,efetuada,data(3,12,2021,08,00)).
encomenda(5,7,43,4,16,7,203,efetuada,data(3,12,2021,08,00)).

encomenda(6,7,43,4,16,4,20,emDistribuicao,data(3,12,2021,08,00)).
encomenda(7,8,40,4,10,5,20,emDistribuicao,data(3,12,2021,08,00)).
encomenda(8,5,40,4,10,9,20,emDistribuicao,data(3,12,2021,08,00)).

%------------------Rota---------------
rota(1,[2,3]).
rota(2,[3,5,4,6]).
rota(3,[6,4,5]).
%-----------------Estafetas------------------
%O ranking é calculado na função 6. com base na lista de encomendas
%estafeta(identificador, nome, lista de encomendas)
estafeta(1,'João',[1,3,4]).
estafeta(2,'Pedro',[2,6,7,8]).

%-----------------Entregas------------------
%entrega(identificador, IdEstafeta, IdEncomenda, data da entrega,avaliação média 0-5,transporte)
entrega(1,1,1,data(5,12,2021,13,00),4,1).
entrega(2,2,2,data(2,12,2021,14,30),2,2).
entrega(3,1,3,data(3,12,2021,09,30),4,3).
entrega(4,1,4,data(4,12,2021,17,50),5,1).
entrega(5,2,5,data(4,12,2021,10,00),5,1).

entrega(6,2,6,data(3,12,2021,12,00),5,porDefinir).
entrega(7,2,6,data(3,12,2021,12,00),5,porDefinir).
%------------------MeiosTransporte-------------
%transporte(identificador,nome, peso máximo, velocidade média, indice ecologico 1-3)
transporte(1,'bicicleta',5,10,3).
transporte(2,'moto',20,35,2).
transporte(3,'carro',100,50,1).


%-----------------Ruas------------------
%rua(identificador, nome da rua)
rua(1,'Centro de Logistica').
rua(2,'Rua Sete Céus').
rua(3,'Rua do Açúcar').
rua(4,'Rua Arlindo Nogueira').
rua(5,'Rua Carlos Augusto').
rua(6,'Rua Pereira Estéfano').
rua(7,'Avenida Tocantins').
rua(8,'Avenida Afonso Pena').
rua(9,'Rua Domingos Olímpio').
rua(10,'Avenida São João').
rua(11,'Rodovia Raposo Tavares').
rua(12,'Rua Tenente Cardoso').



%cliente(identificador,nome,nif, idencomenda)
cliente(1,'Sara Rodrigues',123456789, 1).
cliente(2,'Henrique Marques',023456789, 2).
cliente(3,'Leonor Losa',234234233, 3).
cliente(4,'Inês Faria',197837476, 4).


