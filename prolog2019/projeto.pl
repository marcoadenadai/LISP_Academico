% vôo(origem,destino,código,partida,(dia_chegada,horario_chegada), num_escala,
% companhia,[dias]).
%gol tam e azuL?
voo(sao_paulo,madrid,gl1,8:25,(mesmo,20:25),0,gol,[qua,sex,dom]).
voo(sao_paulo,madrid,tm3,22:00,(seguinte,8:00),1,tam,[seg,qua,sex]).

voo(sao_paulo,madrid,tm3,22:00,(seguinte,8:00),1,tam,[seg,qua,sex]).

voo(madrid,frankfurt,xxx,12:00,(mesmo,17:00),0,tam,[seg,ter,qua,qui,sex,sab,dom]).
voo(frankfurt,roma,rrr,11:00,(mesmo,17:00),0,tam,[seg,ter,qua,qui,sex,sab,dom]).
voo(madrid,roma,fff,15:00,(mesmo,19:00),0,tam,[seg,ter,qua,qui,sex,sab,dom]).
voo(madrid,roma,fff,15:00,(mesmo,19:00),0,tam,[seg,ter,qua,qui,sex,sab,dom]).

% voo(Ori,Des,Cod,HPart,(DCheg,HCheg),N,Comp,[Dias_Sem]).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% ===========================================================================================
% ===========================================================================================
% QUESTAO 1,    Verificar se é possível ir de uma cidade a outra, através de um vôo direto.
% ----------------------------------------------------
pertence(X,[X|_]).  %Se X estiver na cabeça, true
pertence(X,[_|T]) :- pertence(X,T). %Analisa o restante da lista jogando 1 a 1 para a cabeça
% ----------------------------------------------------

voo_direto(Ori,Des,Companhia,DSem,
H) :- 
voo(Ori,Des,_,H,(_,_),0,Companhia,X),pertence(DSem,X).
% ===========================================================================================
% ===========================================================================================





% ===========================================================================================
% ===========================================================================================
% QUESTAO 2,    Existe voo entre 2 cidades num determinado dia da semana?
filtra_voo_dia_semana(Origem,Destino, DiaSemana,
HorarioSaida,HorarioChegada,Companhia) :-
    voo(Origem,Destino,_,HorarioSaida,HorarioChegada,_,Companhia,X),
    pertence(DiaSemana,X). 
% ===========================================================================================
% ===========================================================================================   





% ===========================================================================================
% =========================================================================================== 
% QUESTAO 3,    É possível viajar de uma cidade a outra (pode varios voos)?
% return = lista de codigos dos voos.
% ----------------------------------------------------
inverte(L,R) :- %cria subfunção
    inverte_1(L,R,[]). %parametro1 = Lista a ser inverta // p2 = Resultado // p3 = lista temporaria
inverte_1([],T,T).  %se a lista a ser invertida for vazia, o temporario sera o retorno
inverte_1([H|T],X,L) :- inverte_1(T,X,[H|L]).   %senão, inverte a lista [H|T], dando oresultado em X usando L como temporaria
% ----------------------------------------------------

roteiro(Origem, Destino, L) :-      %retorno em L
    roteiro_1(Origem, Destino, [], L1), %chama subfuncao para lista temporaria
    inverte(L1,L).  %inverte a lista dada pela subfuncao e joga em L

roteiro_1(B,B,TMP,TMP). %Se chegar no destino, acaba e retorna a lista temporaraia para lista final
roteiro_1(A,B,TMP,L) :-
    voo(A,X,Cod,_,(_,_),_,_,_), %se existir o voo da origem até X
    \+ pertence(Cod,TMP),       %e não pertencer a lista temporaria (rota)
    roteiro_1(X,B,[Cod|TMP],L). %chama subfuncao roteiro_1 partindo do ponto X para chegar em B, 
                                % passando o código do voo A->X para a lista temporaria
% ===========================================================================================
% =========================================================================================== 





% ===========================================================================================
% =========================================================================================== 
% QUESTAO 4,    Qual é o voo de menor duração entre 2 cidades num determinado dia da semana?
% ----------------------------------------------------
convert_hhmm2min(HHMM, NUM) :-
    term_string(HHMM,S),
    split_string(S,':','',L),
    nth1(1,L,HH),
    number_string(H,HH),
    nth1(2,L,MM),
    number_string(M,MM),
    NUM is 60*H+M.
% ----------------------------------------------------
dura_voo(Codigo,Duracao) :-
    voo(_,_,Codigo,HPart,(DCheg,HCheg),_,_,_),
    convert_hhmm2min(HCheg,F),
    convert_hhmm2min(HPart,I),
    (DCheg = mesmo ->
    Duracao is F-I;
    DCheg = seguinte ->
    Duracao is F+1440-I).
% ----------------------------------------------------
lista_cod2dura(C,D) :-
    cod2dura_1(C,D,[]).
cod2dura_1([],TMP,TMP).
cod2dura_1([A|B],D,TMP) :-
    cod2dura_1(B,D, [X|TMP]),
    dura_voo(A,X).
% ----------------------------------------------------
existe_voo(Origem,Destino,Cod,DiaSemana) :-
    voo(Origem,Destino,Cod,_,(_,_),_,_,X),
    pertence(DiaSemana,X).
% ----------------------------------------------------
horarios_by_cod(Cod,HSaida,HChegada,Companhia) :-
    voo(_,_,Cod,HSaida,HChegada,_,Companhia,_).
% ----------------------------------------------------
menor_lista([X],X). %pega o menor elemento da lista
menor_lista([X,Y|T],Min) :-
    X =< Y,
    !, menor_lista([X|T],Min).
menor_lista([_,Y|T],Min) :- menor_lista([Y|T],Min).
% ----------------------------------------------------
indice_lista([E|_], E, 1) :- !.
indice_lista([_|T], E, Ind) :-
    indice_lista(T, E, TMP),
    !,
    Ind is TMP+1.
% ----------------------------------------------------

menorDuracao(Origem,Destino,DiaSemana
    ,HorarioSaida,HorarioChegada,Companhia) :-
        findall(Cod,existe_voo(Origem,Destino,Cod,DiaSemana),LC),
        %encontro lista de codigos de voo que satisfazem tais exigencias
        lista_cod2dura(LC,LD),
        %converto uma lista de codigos para uma lista de duracoes do voo
        menor_lista(LD,MenorD),
        %pego a menor duracao de voo
        indice_lista(LD,MenorD,N),
        %pego o indice da posicao na lista de duracoes da menor duracao
        nth1(N,LC,C),
        %C = codigo do voo de menor duracao da lista de voos
        horarios_by_cod(C,HorarioSaida,HorarioChegada,Companhia).
        %dou o retorno
% ===========================================================================================
% =========================================================================================== 





% ===========================================================================================
% =========================================================================================== 
% QUESTAO 5,    Qual a duração de um voo entre 2 cidades (pode varios voos)?
%roteiro(Origem, Destino,
%DSaida, HSaida, Duracao) :-
%    roteiro(Origem,Destino,L).%,
% ===========================================================================================
% =========================================================================================== 