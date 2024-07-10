ec(X, Y) :- ec(Y, X).
po(X, Y) :- po(Y, X).
ntpp(X, Z) :- ntpp(X, Y) & ntpp(Y, Z).