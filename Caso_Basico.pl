%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Establecemos columnas y creamos el tablero %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

col(0).
col(1).
col(2).
col(3).
col(4).
col(5).
col(6).

%tablero de juego, consiste en una lista de listas 6x7 que representa el tablero del conecta4.
%Se rellena inicialmente con espacios en blanco
tablero([[' ',' ',' ',' ',' ',' '],
         [' ',' ',' ',' ',' ',' '],
         [' ',' ',' ',' ',' ',' '],
         [' ',' ',' ',' ',' ',' '],
         [' ',' ',' ',' ',' ',' '],
         [' ',' ',' ',' ',' ',' '],
         [' ',' ',' ',' ',' ',' ']]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Comienzo del juego %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%la llamada a este predicado comienza el juego
jugar():- tablero(X),mostrarTablero(X),jugando('X',X).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Mostrar tablero %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mostrarTablero(X):-nl, write(" 0 1 2 3 4 5 6"),
                 mostrarContenido(X,6).

%Carácteres unicode
mostrarContenido(_,0):- nl,write('\u255a\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u255D').
mostrarContenido(X,N):- Ns is N-1,nl,write('\u2560\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2563'),nl,write('\u2551'),
             imprimirLinea(X,X2),
             mostrarContenido(X2,Ns).
%mostrarLinea, muestra una linea del tablero, realmente muestra la primera posición de cada lista en la lista de listas
imprimirLinea([],_).   %Caso base
imprimirLinea([[X|X2]|XR],[X2|XR2]):- write(X),write('\u2551'),   %Caso general
                                 imprimirLinea(XR,XR2).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Movimiento Y juego %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Primero se comprueba que ningún jugador haya ganado ni tampoco que haya un empate
%Para haber un empate debe estar el tablero lleno
jugando('X',X):- victoria('O',X),
    nl,write('O GANA!').
jugando('O',X):- victoria('X',X),
    nl,write('X GANA!').
jugando(_,X):- empate(X),
    nl,write('EMPATE').

%mientras jugando sea false significa que la columna elegida esta llena con lo cual se repite
jugando('X',X):- repeat,
      inputCol(C),
      introducir('X',C,X,X2),
      mostrarTablero(X2),
      jugando('O',X2).

jugando('O',X):- repeat,
      inputCol(C),
      introducir('O',C,X,X2),
      mostrarTablero(X2),
      jugando('X',X2).
%cuando una ficha es introducida con éxito se llama a jugar al contrincante

%pide numeros hasta que se encuntran dentro de las columnas (C) definidas
inputCol(C):-repeat,
    nl, write('Introduce columna: '),
    read(C),
    col(C).

%introduce una ficha en la columna deseada. P es la posición, F la ficha, X el tablero
%X2 el tablero resultante
introducir(F,P,X,X2):- append(L,[C|K],X), %se guarda en C la columna a modificar
             length(L,P),    %L tiene que medir P
             introducirCol(F,C,C2),
             append(L,[C2|K],X2). %concatena L y K con la nueva C, es decir las dos mitades por las que divide C

%Si la columna no tiene un espacio en la primera posicion, da false
%X es la ficha a introducir.
introducirCol(X,[' '],[X]):- !.   %Caso base
introducirCol(X,[' ',E|C2],[X,E|C2]):- E \== (' '), !. %Caso base 2
introducirCol(X,[' '|C2],[' '|CA2]):- introducirCol(X,C2,CA2).     %Caso general

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Condiciones de fin de partida %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

empate(X):- \+ (append(_,[C|_],X),append([' '|_],_,C)).

victoria(X,T):-
       %4 fichas seguidas en la misma columna
       append(_, [C|_], T), % una columna C
       append(_,[X,X,X,X|_],C). %  con cuatro fichas del mismo tipo en cualquier lugar

victoria(X,T):-
       %4 fichas seguidas en la misma fila
       append(_,[C1,C2,C3,C4|_],T),   %cuatro columnas consecutivas
       append(P1,[X|_],C1),       %que tienen la ficha X en algun lugar
       append(P2,[X|_],C2),
       append(P3,[X|_],C3),
       append(P4,[X|_],C4),
       length(P1,K), length(P2,K), length(P3,K), length(P4,K).  %y esa ficha esta siempre al mismo nivel

victoria(X,T):-
       %4 fichas seguidas en diagonal hacia abajo-derecha
       append(_,[C1,C2,C3,C4|_],T),
       append(P1,[X|_],C1),
       append(P2,[X|_],C2),
       append(P3,[X|_],C3),
       append(P4,[X|_],C4),
       length(P1,K1), length(P2,K2), length(P3,K3), length(P4,K4),
       K2 is K1+1, K3 is K2+1, K4 is K3+1.

victoria(X,T):-
       %4 fichas seguidas en diagonal hacia arriba-derecha
       append(_,[C1,C2,C3,C4|_],T),
       append(P1,[X|_],C1),
       append(P2,[X|_],C2),
       append(P3,[X|_],C3),
       append(P4,[X|_],C4),
       length(P1,K1), length(P2,K2), length(P3,K3), length(P4,K4),
       K2 is K1-1, K3 is K2-1, K4 is K3-1.