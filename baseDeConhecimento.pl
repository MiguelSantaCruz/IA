:-set_prolog_flag(discontiguous_warnings,off).
:-set_prolog_flag(single_var_warnings,off).
:-set_prolog_flag(answer_write_options,[max_depth(0)]).




%:- dynamic (transporte/3).
%:- dynamic (rua/3).
%:- dynamic (encomenda/2).
%:- dynamic (cliente/2).
%:- dynamic (estafeta/2).
%:- dynamic (entrega/2).


%BASE DO CONHECIMENTO

%------------------MeiosTransporte-------------
%transporte(identificador,nome, peso máximo, velocidade média, indice ecologico 1-3)
transporte(1,'bicicleta',5,10,3).
transporte(2,'moto',20,35,2).
transporte(3,'carro',100,25,1).

%-----------------Ruas------------------
%rua(identificador, nome da rua, nome da freguesia, distancia ao centro de logistica)
rua(1,'Paraíso','Nogueira',3).
rua(2,'Sete Céus','Lindoso',5).
rua(3,'Açúcar','Oleiros',2).

%-----------------Encomendas------------------
%encomenda(identificador, peso, volume, cliente, prazo de entrega(horas),rua,transporte, preço,data de encomenda)
encomenda(1,5,53,1,6,1,1,20,data(5,12,2021,07,00)).
encomenda(2,13,20,2,12,3,2,30,data(1,12,2021,01,00)).
encomenda(3,2,3,3,24,6,1,2022,data(2,12,2021,19,00)).
encomenda(4,7,43,4,16,8,1,203,data(3,12,2021,08,00)).

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
