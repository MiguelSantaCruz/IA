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
	write('\u001b[34m[6]\u001b[0m Calcular a classificação média de satisfação de cliente para um determinado estafeta'),nl,
	write('\u001b[34m[7]\u001b[0m Número total de entregas pelos diferentes meios de transporte num intervalo de tempo'),nl,
	write('\u001b[34m[8]\u001b[0m Número total de entregas por estafetas, num intervalo de tempo'),nl,
	write('\u001b[34m[9]\u001b[0m Calcular o número de encomendas entregues e não entregues'),nl,
	write('\u001b[34m[10]\u001b[0m Calcular o peso total transportado por estafeta num determinado dia.'),nl,
	nl,
	write('Insira escolha: '),
	read(Escolha),
	validaEscolha(Escolha),
	executa(Escolha),
  	nl,nl,fail.
 
%Função que valida as escolhas feitas( se estão entre 1 e 10)  
validaEscolha(X) :- X =< 0,write('\u001b[31mEscolha inválida\u001b[0m'),nl,!,fail.
validaEscolha(X) :- X > 10,write('\u001b[31mEscolha inválida\u001b[0m'),nl,!,fail.
validaEscolha(_).

%Função que chama as funções que implementam as funcionalidades
executa(X) :- X =:= 1, write('\u001b[31mNão implementado!\u001b[0m'). 
executa(X) :- X =:= 2, write('\u001b[31mNão implementado!\u001b[0m').  
executa(X) :- X =:= 3, write('\u001b[31mNão implementado!\u001b[0m'). 
executa(X) :- X =:= 4, write('\u001b[31mNão implementado!\u001b[0m'). 
executa(X) :- X =:= 5, write('\u001b[31mNão implementado!\u001b[0m'). 
executa(X) :- X =:= 6, write('\u001b[31mNão implementado!\u001b[0m'). 
executa(X) :- X =:= 7, write('\u001b[31mNão implementado!\u001b[0m').  
executa(X) :- X =:= 8, write('\u001b[31mNão implementado!\u001b[0m').  
executa(X) :- X =:= 9, write('\u001b[31mNão implementado!\u001b[0m'). 
executa(X) :- X =:= 10, write('\u001b[31mNão implementado!\u001b[0m').  
