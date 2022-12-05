:- use_module(library(dcg/basics)).

solution(F, X, Y) :-
    file_chars(F, Chars),
    phrase(pairs(X, Y), Chars).

file_chars(File, Chars) :-
    setup_call_cleanup(open(File, read, In),
       stream_chars(In, Chars),
       close(In)).

stream_chars(In, Chars) :-
    read_string(In, _, Str),
    string_chars(Str, Chars).

pairs(Z1, Z2) --> pair(X1, X2), ['\n'], pairs(Y1, Y2), {Z1 is X1 + Y1, Z2 is X2 + Y2}.
pairs(X, Y) --> pair(X, Y).

pair(A, B) --> range(X), [','], range(Y), {encode(try_swap(contains, X, Y), A), encode(try_swap(overlaps, X, Y), B)}.

range((X,Y)) --> number(X), [-], number(Y).

contains((X1, Y1), (X2, Y2)) :- X1 =< X2, Y1 >= Y2.

overlaps((X1, Y1), (X2, Y2)) :- Y1 >= X2, Y1 =< Y2.

try_swap(P, X, Y) :- call(P, X, Y) ; call(P, Y, X).

encode(P, V) :- call(P) -> V = 1 ; V = 0.
