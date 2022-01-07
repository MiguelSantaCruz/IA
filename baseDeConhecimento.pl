:-set_prolog_flag(discontiguous_warnings,off).
:-set_prolog_flag(single_var_warnings,off).
:-set_prolog_flag(answer_write_options,[max_depth(0)]).




:- dynamic (transporte/3).
:- dynamic (rua/3).
:- dynamic (encomenda/2).
:- dynamic (cliente/2).
:- dynamic (estafeta/2).
:- dynamic (entrega/2).
:- dynamic (estrada/2).


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

%------------------MeiosTransporte-------------
%transporte(identificador,nome, peso máximo, velocidade média, indice ecologico 1-3)
transporte(1,'bicicleta',5,10,3).
transporte(2,'moto',20,35,2).
transporte(3,'carro',100,45,1).

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

%----------Estima distâncias-----------

estima(1,0).
estima(2,3).
estima(3,5).
estima(4,6).
estima(5,1).
estima(6,3).
estima(7,15).
estima(8,16).
estima(9,29).
estima(10,16).
estima(11,5).
estima(12,14).
goal(1).

%-----------------Andar------------------
%andar(identificador, id_estrada)
andar(1,1).
andar(2,2).


%-----------------Encomendas------------------
%encomenda(identificador, peso, volume, cliente, prazo de entrega(horas),rua,transporte, preço,data de encomenda)
encomenda(1,5,53,1,6,1,1,20,data(5,12,2021,07,00)).
encomenda(2,13,20,2,12,3,2,30,data(1,12,2021,01,00)).
encomenda(3,2,3,3,24,6,3,2022,data(2,12,2021,19,00)).
encomenda(4,7,43,4,16,8,1,203,data(3,12,2021,08,00)).
encomenda(5,7,43,4,16,8,1,203,data(3,12,2021,08,00)).
%-----------------Clientes------------------
%cliente(identificador,nome,nif, idencomenda)
cliente(1,'Sara Rodrigues',123456789, 1).
cliente(2,'Henrique Marques',023456789, 2).
cliente(3,'Leonor Losa',234234233, 3).
cliente(4,'Inês Faria',197837476, 4).

%-----------------Estafetas------------------
%O ranking é calculado na função 6. com base na lista de encomendas
%estafeta(identificador, nome, lista de encomendas)
estafeta(1,'João',[1,3,4]).
estafeta(2,'Pedro',[2]).

%-----------------Entregas------------------
%entrega(identificador, IdEstafeta, encomenda, data da entrega,avaliação média 0-5)
entrega(1,1,1,data(5,12,2021,13,00),4).
entrega(2,2,2,data(2,12,2021,14,30),2).
entrega(3,1,3,data(3,12,2021,09,30),4).
entrega(4,1,4,data(4,12,2021,17,50),5).
entrega(5,2,5,data(4,12,2021,10,00),5).
