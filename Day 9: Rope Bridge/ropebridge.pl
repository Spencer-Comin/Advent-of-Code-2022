:- use_module(library(dcg/basics)).

solution(F, X) :-
    file_codes(F, C),
    phrase(motions((0, 0), (0, 0), [(0, 0)], _, _, Positions), C),
    length(Positions, X).

file_codes(F, C) :-
    setup_call_cleanup(open(F, read, In),
       read_stream_to_codes(In, C),
       close(In)).

motions(H, T, P, HHH, TTT, PPP) --> motion(H, T, P, HH, TT, PP), [0'\n], motions(HH, TT, PP, HHH, TTT, PPP).
motions(H, T, P, HH, TT, PP) --> motion(H, T, P, HH, TT, PP).

motion(H, T, P, HH, TT, PP) --> [D, 0' ], string_without([0'\n], C),
{
    atom_codes(Direction, [D]),
    number_codes(Count, C),
    execute(Direction, Count, H, T, HH, TT, Positions),
    ord_union(P, Positions, PP)
}.

execute(Direction, 1, HeadIn, TailIn, HeadOut, TailOut, [TailOut]) :- execute(Direction, HeadIn, TailIn, HeadOut, TailOut).
execute(Direction, Count, HeadIn, TailIn, HeadOut, TailOut, Positions) :-
    execute(Direction, HeadIn, TailIn, NextHead, NextTail),
    Count > 1,
    NextCount is Count - 1,
    execute(Direction, NextCount, NextHead, NextTail, HeadOut, TailOut, NextPositions),
    ord_add_element(NextPositions, NextTail, Positions).

execute(Direction, HeadIn, TailIn, HeadOut, TailOut) :-
    move_head(HeadIn, Direction, HeadOut),
    move_tail(HeadOut, TailIn, TailOut).

move_head((X, Y), 'U', (X, YY)) :- YY is Y + 1.
move_head((X, Y), 'D', (X, YY)) :- YY is Y - 1.
move_head((X, Y), 'L', (XX, Y)) :- XX is X + 1.
move_head((X, Y), 'R', (XX, Y)) :- XX is X - 1.

move_tail((HX, HY), (TX, _), (NX, HY)) :-
    HX-TX > 1,
    NX is HX - 1, !.

move_tail((HX, HY), (_, TY), (HX, NY)) :-
    HY-TY > 1,
    NY is HY - 1, !.

move_tail((HX, HY), (TX, _), (NX, HY)) :-
    TX-HX > 1,
    NX is HX + 1, !.

move_tail((HX, HY), (_, TY), (HX, NY)) :-
    TY-HY > 1,
    NY is HY + 1, !.

move_tail(_, T, T).
