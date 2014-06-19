% vim: set ft=prolog:

%  Para executar os testes, utilize o comando make testar (no diretório
%  tetravex). Você também pode executar testes ou conjunto de testes
%  específicos no interpretador prolog. Após carregar o arquivo testes.pl,
%  execute a consulta
%
%  run_tests(tetravex:na_borda_superior). % para executar o teste na_borda_superior
%
%  run_tests(tetravex).                   % para executar os testes básicos
%
%  run_tests(tetravex_grandes).           % para executar os testes para os jogos grandes
%
%  run_tests(tetravex_desafio).           % para executar os testes do desafio
%
%  Alguns testes utilizam um jogo com 3 linhas e 5 colunas. Você pode
%  visualizar as relações de adjacência no esquema a seguir.
%
%   0  1  2  3  4
%   5  6  7  8  9
%  10 11 12 13 14
%
%  Leia o propósito de cada predicado no arquivo tetravex.pl.

:- consult(tetravex).
:- use_module(library(plunit)).


:- begin_tests(tetravex).

% Testes para o predicado principal solucao/2
% Veja o predicao teste_caso/1 no final deste arquivo.

test(solucao1x1) :-
    teste_caso(teste1x1).

test(solucao2x2) :-
    teste_caso(teste2x2).

test(solucao3x3) :-
    teste_caso(teste3x3).

% Testes para os demais predicados
% Você deve escrever os testes para os novos predicados que você definir.

test(na_borda_superior) :-
    jogo_tetravex(Jogo, 3, 5),
    na_borda_superior(Jogo, 0),
    na_borda_superior(Jogo, 1),
    na_borda_superior(Jogo, 2),
    na_borda_superior(Jogo, 3),
    na_borda_superior(Jogo, 4).

test(na_borda_superior, fail) :-
    jogo_tetravex(Jogo, 3, 5),
    na_borda_superior(Jogo, 5).

test(pos_acima, A =:= 2) :-
    jogo_tetravex(Jogo, 3, 5),
    % a posição acima da posição 7 é a posição A =:= 2
    pos_acima(Jogo, 7, A).

% posição 1
%    5
%  8   2
%    7
%
% posição 6
%    7
%  9   4
%    6
test(corresponde_acima) :-
    jogo_tetravex(Jogo, 3, 5),
    bloco_pos(Jogo, 1, bloco(5, 2, 7, 8)),
    bloco_pos(Jogo, 6, bloco(7, 4, 6, 9)),
    % não tem ninguém acima de 1, portanto corresponde
    corresponde_acima(Jogo, 1),
    % quem está acima de 6 é o 1, na borda superior da posição 6, tem o 7, e na
    % borda inferior da posição 1 tem o 7, portanto corresponde
    corresponde_acima(Jogo, 6).

test(corresponde_acima, fail) :-
    jogo_tetravex(Jogo, 3, 5),
    bloco_pos(Jogo, 1, bloco(5, 2, 7, 8)),
    bloco_pos(Jogo, 6, bloco(3, 4, 6, 9)),
    % não corresponde, no lugar do 3 deveria ser 7
    corresponde_acima(Jogo, 6).

:- end_tests(tetravex).


:- begin_tests(tetravex_grande).

test(solucao_grandes) :-
    teste_caso(teste4x4),
    teste_caso(teste5x5),
    teste_caso(teste6x6).

:- end_tests(tetravex_grande).


:- begin_tests(tetravex_desafio).

test(desafio) :-
    teste_caso(teste7x7).

:- end_tests(tetravex_desafio).


teste_caso(Caso) :-
    call(Caso, Blocos, Linhas, Colunas),
    reverse(Blocos, BlocosRev),
    jogo_tetravex(Jogo, Linhas, Colunas),
    % a lista dos blocos é dada na ordem inversa
    solucao(Jogo, BlocosRev),
    tetravex(_, _, R) = Jogo,
    % você pode descomentar a linha a seguir para ver o resultado encontrado pelo seu predicado solucao
    % write(R), nl,
    % a resposta deve ser a lista dos blocos na ordem normal
    R == Blocos.

teste1x1(Blocos, 1, 1) :-
    Blocos = [bloco(3, 6, 7, 5)].

teste2x2(Blocos, 2, 2) :-
    Blocos = [
        bloco(3, 4, 7, 9),
        bloco(6, 9, 5, 4),
        bloco(7, 6, 5, 2),
        bloco(5, 3, 6, 6)].

teste3x3(Blocos, 3, 3) :-
    Blocos = [
        bloco(7, 3, 4, 9),
        bloco(3, 4, 8, 3),
        bloco(7, 4, 2, 4),
        bloco(4, 4, 8, 5),
        bloco(8, 3, 6, 4),
        bloco(2, 2, 7, 3),
        bloco(8, 9, 1, 3),
        bloco(6, 6, 6, 9),
        bloco(7, 8, 5, 6)].

teste4x4(Blocos, 4, 4) :-
    Blocos = [
        bloco(7, 7, 4, 8),
        bloco(3, 0, 2, 7),
        bloco(7, 9, 1, 0),
        bloco(1, 6, 3, 9),
        bloco(4, 2, 5, 5),
        bloco(2, 4, 5, 2),
        bloco(1, 5, 7, 4),
        bloco(3, 8, 0, 5),
        bloco(5, 5, 8, 0),
        bloco(5, 5, 9, 5),
        bloco(7, 6, 7, 5),
        bloco(0, 2, 1, 6),
        bloco(8, 7, 9, 5),
        bloco(9, 2, 8, 7),
        bloco(7, 3, 3, 2),
        bloco(1, 0, 4, 3)].

teste5x5(Blocos, 5, 5) :-
    Blocos = [
        bloco(1, 6, 7, 5),
        bloco(4, 0, 0, 6),
        bloco(9, 2, 0, 0),
        bloco(8, 3, 5, 2),
        bloco(0, 4, 5, 3),
        bloco(7, 1, 2, 6),
        bloco(0, 4, 5, 1),
        bloco(0, 0, 3, 4),
        bloco(5, 1, 1, 0),
        bloco(5, 3, 2, 1),
        bloco(2, 9, 1, 0),
        bloco(5, 5, 5, 9),
        bloco(3, 2, 2, 5),
        bloco(1, 0, 6, 2),
        bloco(2, 9, 0, 0),
        bloco(1, 0, 7, 0),
        bloco(5, 0, 7, 0),
        bloco(2, 4, 8, 0),
        bloco(6, 9, 4, 4),
        bloco(0, 0, 6, 9),
        bloco(7, 0, 2, 5),
        bloco(7, 2, 0, 0),
        bloco(8, 6, 1, 2),
        bloco(4, 4, 6, 6),
        bloco(6, 5, 8, 4)].

teste6x6(Blocos, 6, 6) :-
    Blocos = [
        bloco(3, 0, 2, 4),
        bloco(9, 5, 5, 0),
        bloco(1, 1, 8, 5),
        bloco(4, 2, 0, 1),
        bloco(4, 3, 2, 2),
        bloco(8, 0, 0, 3),
        bloco(2, 2, 3, 9),
        bloco(5, 9, 1, 2),
        bloco(8, 2, 3, 9),
        bloco(0, 2, 3, 2),
        bloco(2, 9, 8, 2),
        bloco(0, 6, 9, 9),
        bloco(3, 1, 6, 9),
        bloco(1, 2, 2, 1),
        bloco(3, 0, 8, 2),
        bloco(3, 5, 8, 0),
        bloco(8, 7, 8, 5),
        bloco(9, 4, 8, 7),
        bloco(6, 0, 6, 9),
        bloco(2, 4, 5, 0),
        bloco(8, 7, 6, 4),
        bloco(8, 3, 7, 7),
        bloco(8, 7, 2, 3),
        bloco(8, 7, 1, 7),
        bloco(6, 3, 9, 0),
        bloco(5, 1, 9, 3),
        bloco(6, 9, 8, 1),
        bloco(7, 7, 0, 9),
        bloco(2, 0, 6, 7),
        bloco(1, 3, 7, 0),
        bloco(9, 9, 8, 7),
        bloco(9, 0, 6, 9),
        bloco(8, 1, 6, 0),
        bloco(0, 9, 7, 1),
        bloco(6, 1, 7, 9),
        bloco(7, 8, 1, 1)].

teste7x7(Blocos, 7, 7) :-
    Blocos = [
        bloco(4, 1, 0, 8),
        bloco(7, 8, 1, 1),
        bloco(0, 3, 5, 8),
        bloco(4, 0, 9, 3),
        bloco(9, 7, 1, 0),
        bloco(6, 8, 3, 7),
        bloco(3, 5, 2, 8),
        bloco(0, 9, 5, 8),
        bloco(1, 4, 9, 9),
        bloco(5, 1, 6, 4),
        bloco(9, 3, 1, 1),
        bloco(1, 5, 6, 3),
        bloco(3, 3, 2, 5),
        bloco(2, 0, 4, 3),
        bloco(5, 1, 8, 8),
        bloco(9, 6, 8, 1),
        bloco(6, 5, 2, 6),
        bloco(1, 8, 6, 5),
        bloco(6, 4, 9, 8),
        bloco(2, 8, 2, 4),
        bloco(4, 1, 8, 8),
        bloco(8, 1, 5, 4),
        bloco(8, 2, 0, 1),
        bloco(2, 0, 2, 2),
        bloco(6, 4, 8, 0),
        bloco(9, 7, 7, 4),
        bloco(2, 8, 5, 7),
        bloco(8, 0, 7, 8),
        bloco(5, 6, 0, 8),
        bloco(0, 9, 4, 6),
        bloco(2, 2, 2, 9),
        bloco(8, 9, 5, 2),
        bloco(7, 1, 5, 9),
        bloco(5, 2, 0, 1),
        bloco(7, 9, 6, 2),
        bloco(0, 7, 5, 8),
        bloco(4, 7, 5, 7),
        bloco(2, 9, 1, 7),
        bloco(5, 7, 5, 9),
        bloco(5, 5, 4, 7),
        bloco(0, 8, 5, 5),
        bloco(6, 8, 7, 8),
        bloco(5, 7, 9, 6),
        bloco(5, 0, 2, 7),
        bloco(1, 4, 6, 0),
        bloco(5, 3, 2, 4),
        bloco(4, 9, 6, 3),
        bloco(5, 8, 1, 9),
        bloco(7, 8, 0, 8)].
