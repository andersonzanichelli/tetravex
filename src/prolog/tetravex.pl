% vim: set ft=prolog:

%  Este arquivo contém a estrutura inicial de um resolvedor do jogo tetravex.
%
%  O predicado principal é solucao/2. Os demais predicados ajudarão na escrita
%  do predicado principal. Para cada predicado existe um conjunto de testes
%  correspondente no arquivo testes.pl. Você deve ler o propósito do predicado
%  e os testes e depois escrever o corpo do predicado de maneira a atender o
%  propósito e passar nos testes. Comece a escrever a implementação do último
%  predicado para o primeiro (na sequência inversa que os predicados aparecem
%  neste arquivo). Você deve criar os demais predicados auxiliares e escrever
%  os testes correspondentes no arquivo teste.pl.
%
%  O predicado solucao/2 tem uma implementação inicial ingênua. Esta
%  implementação irá ajudar a testar os demais predicados. Uma vez que os
%  testes tetravex:solucao1x1, tretravex:solucao2x2 e tetravex:solucao3x3
%  estiverem passando, você deve escrever uma implementação para solucao/2 mais
%  eficiente de maneira que o teste tetravex:solucao_grandes execute
%  rapidamente.
%
%  Um jogo tetravex é representado por uma estrutura tetravex com 3 argumentos.
%  O primeiro é o número de linhas, o segundo o número de colunas e o terceiro
%  uma lista (de tamanho linhas x colunas) com os blocos que compõem a solução.
%  Inicialmente os elementos desta lista de blocos não estão instanciados, eles
%  são instanciados pelo predicado solucao/2. Cada bloco é identificado por um
%  número inteiro que corresponde a sua posição na lista de blocos. Por
%  exemplo, em um tetravex com 3 linhas e 5 colunas (total de 15 blocos), os
%  blocos são enumerados da seguinte forma
%
%   0  1  2  3  4
%   5  6  7  8  9
%  10 11 12 13 14
%
%  Cada bloco é representado por uma estrutura bloco com 4 argumentos. Os
%  argumentos representam os valores da borda superior, direita, inferior e
%  esquerda (sentido horário começando do topo). Por exemplo o bloco
%  |  3  |
%  |4   6|  é representado por bloco(3, 6, 7, 4).
%  |  7  |


%% solucao(Jogo?, Blocos+) is semidet
%
%  Verdadeiro se Jogo é um jogo tetravex válida para o conjunto Blocos.
%  Blocos contém a lista de blocos que devem ser "colocadas" no Jogo.

solucao(Jogo, Blocos) :-
	tetravex(_, _, R) = Jogo,
	same_length(Blocos, R),
	resolvido(Jogo, Blocos, 0),!.

%% resolvido(Jogo+, Blocos?, Pos+) is semidet
%
%  Verdadeiro se Jogo e um tetravex valido e com todos os blocos
%  organizados.

resolvido(_, [], _).

resolvido(Jogo, Blocos, Pos) :-
	select(Candidato, Blocos, Resto),
	bloco_pos(Jogo, Pos, Candidato),
	blocos_correspondem(Jogo, Pos),
	ProximaPos is Pos + 1,
	resolvido(Jogo, Resto, ProximaPos).


%% blocos_correspondem(Jogo?, Pos) is semidet
%
%  Verdadeiro se todos os blocos de Jogo correspondem com seus adjacentes.
%  Isto é, se todos os blocos estão dispostos de maneira que suas bordas
%  adjacentes tenham o mesmo número.

blocos_correspondem(Jogo, Pos) :-
	corresponde_acima(Jogo, Pos),
	corresponde_direita(Jogo, Pos),
	corresponde_abaixo(Jogo, Pos).

%% corresponde_esquerda(Jogo+, Pos) is semidet
%
% Verdadeiro se o bloco que esta em Pos corresponde com o bloco que esta
% a direita de Pos em Jogo. Isto e, o valor da borda direita do bloco em
% Pos deve ser igual ao valor da borda esquerda do bloco a direita de
% Pos. Se Pos esta na borda direita, entao a posiçao direita
% corresponde.

corresponde_direita(Jogo, Pos) :-
	na_borda_direita(Jogo, Pos),!.

corresponde_direita(Jogo, Pos) :-
	pos_direita(Pos, PosDireita),
	bloco_pos(Jogo, Pos, Bloco),
	bloco_pos(Jogo, PosDireita, BlocoDireita),
	bloco(_, Face, _, _) = Bloco,
	bloco(_, _, _, Face) = BlocoDireita.

%% corresponde_abaixo(Jogo+, Pos) is semidet
%
% Verdadeiro se o bloco que esta em Pos corresponde com o bloco que esta
% a abaixo de Pos em Jogo. Isto e, o valor da borda inferior do bloco em
% Pos deve ser igual ao valor da borda superior do bloco abaixo de
% Pos. Se Pos esta na borda inferior, entao a posiçao abaixo corresponde.

corresponde_abaixo(Jogo, Pos) :-
	na_borda_inferior(Jogo, Pos).

corresponde_abaixo(Jogo, Pos):-
	pos_abaixo(Jogo, Pos, Abaixo),
	bloco_pos(Jogo, Pos, Bloco),
	bloco_pos(Jogo, Abaixo, BlocoAbaixo),
	bloco(_, _, Face, _) = Bloco,
	bloco(Face, _, _, _) = BlocoAbaixo.

%% corresponde_acima(Jogo+, Pos) is semidet
%
%  Verdadeiro se o bloco que está em Pos corresponde com o bloco que está acima
%  de Pos em Jogo. Isto é, o valor da borda superior do bloco em Pos deve ser
%  igual ao valor da borda inferior do bloco acima de Pos. Se Pos está na borda
%  superior, então a posição acima corresponde.

corresponde_acima(Jogo, Pos) :-
	na_borda_superior(Jogo, Pos), !.

corresponde_acima(Jogo, Pos) :-
	pos_acima(Jogo, Pos, Acima),
	bloco_pos(Jogo, Pos, Bloco),
	bloco_pos(Jogo, Acima, BlocoAcima),
	bloco(Face, _, _, _) = Bloco,
	bloco(_, _, Face, _) = BlocoAcima.


%% na_borda_direita(Jogo+, Pos?) is semidet
%
%  Verdadeiro se Pos e uma posiçao na borda direita de Jogo, Ou seja,
%  Pos esta na ultima coluna do Jogo.

na_borda_direita(Jogo, Pos) :-
	tetravex(_, Colunas, _) = Jogo,
	Local = Pos + 1,
	0 is Local mod Colunas.


%% na_borda_superior(Jogo+, Pos?) is semidet
%
%  Verdadeiro se Pos é uma posição na borda superior de Jogo. Ou seja, Pos está
%  na primeira linha.

na_borda_superior(Jogo, Pos) :-
	tetravex(_, Colunas, _) = Jogo,
	Pos < Colunas.


%% na_borda_inferior(Jogo+, Pos?) is semidet
%
% Verdadeiro se Pos e uma posiçao na borda inferior do Jogo, Ou seja,
% Pos esta na ultima linha.

na_borda_inferior(Jogo, Pos) :-
	tetravex(Linhas, Colunas, _) = Jogo,
	S is Linhas * Colunas,
	Ultima is S - Colunas,
	Pos >= Ultima.


%% pos_direita(Pos+, Direita?) is semidet
%
% Verdadeiro se Direita e a posiçao do Bloco a direita do bloco em Pos.

pos_direita(Pos, Direita) :-
	Direita is Pos + 1.


%% pos_acima(Jogo+, Pos+, Acima?) is semidet
%
%  Verdadeiro se a posição Acima está acima de Pos em Jogo.

pos_acima(Jogo, Pos, Acima) :-
    tetravex(_, Colunas, _) = Jogo,
    Acima is Pos - Colunas.


%% pos_abaixo(Jogo+, Pos+, Abaixo?) is semidet
%
% Verdadeiro se a posiçao Abaixo esta abaixo de Pos em Jogo.

pos_abaixo(Jogo, Pos, Abaixo) :-
	tetravex(_, Colunas, _) = Jogo,
	Abaixo is Pos + Colunas.


%% bloco_pos(Jogo?, Pos?, Bloco?) is nondet
%
%  Verdadeiro se Bloco está na posição Pos de Jogo.

bloco_pos(Jogo, Pos, Bloco) :-
    tetravex(_, _, R) = Jogo,
    nth0(Pos, R, Bloco),!.


%% tetravex(Jogo-, Linhas?, Colunas?) is semidet
%
%  Verdadeiro se Jogo é um jogo tetravex de tamanho Linhas x Colunas.

jogo_tetravex(tetravex(Linhas, Colunas, Blocos), Linhas, Colunas) :-
    S is Linhas * Colunas,
    length(Blocos, S).
