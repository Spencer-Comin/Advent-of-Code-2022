% use --traditional
:- use_module(library(dcg/basics)).

solution(F, X) :-
    file_codes(F, C),
    phrase(program(Signals), C),
    aggregate_all(sum(S), important_signal(Signals, S), X).

file_codes(F, C) :-
    setup_call_cleanup(open(F, read, In),
       read_stream_to_codes(In, C),
       close(In)).

program(XXs) --> program([1], Xs), {reverse(XXs, Xs)}.
program(Xs, XXs) --> instruction(Xs, NXs), "\n", program(NXs, XXs).
program(Xs, XXs) --> instruction(Xs, XXs).

instruction([X|T], [X, X|T]) --> "noop".
instruction([X|T], [Y, X, X|T]) --> "addx ", integer(I), {Y is X + I}.

important_signal(Xs, Signal) :-
    nth1(Index, Xs, Elem),
    Index mod 40 =:= 20,
    Signal is Elem * Index.
