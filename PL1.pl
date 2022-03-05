board([[' ',' ',' ',' ',' ',' '],
         [' ',' ',' ',' ',' ',' '],
         [' ',' ',' ',' ',' ',' '],
         [' ',' ',' ',' ',' ',' '],
         [' ',' ',' ',' ',' ',' '],
         [' ',' ',' ',' ',' ',' '],
         [' ',' ',' ',' ',' ',' ']]).

show(X):- write(" 1 2 3 4 5 6 7"),
                 iShow(X,6).
iShow(_,0):- nl,write("---------------").
iShow(X,N):- Ns is N-1,nl,write("---------------"),nl,write("|"),
             showLine(X,X2),
             iShow(X2,Ns).
showLine([],_).
showLine([[X|X2]|XR],[X2|XR2]):- write(X),write("|"),
                                 showLine(XR,XR2).

conecta4():- board(X),show(X).
