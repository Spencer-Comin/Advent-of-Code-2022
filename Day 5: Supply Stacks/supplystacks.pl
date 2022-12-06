% use --traditional
:- use_module(library(dcg/basics)).
:- use_module(library(clpfd)).

solution(F, X) :-
    file_codes(F, S),
    phrase(plan(X), S).

file_codes(F, S) :-
    setup_call_cleanup(open(F, read, In),
       read_stream_to_codes(In, S),
       close(In)).

plan(Tops) --> drawing(Stacks), "\n\n", directions(Stacks, Out),
{
    maplist(head, Out, Heads),
    string_codes(Tops, Heads)
}.

head([H|_],H).

drawing(S) --> stacks(R), "\n", stack_numbers, {transpose(R, SS), maplist(exclude('='(nil)), SS, S)}.

stacks([H|T]) --> stack_row(H), "\n", stacks(T), {}.
stacks([R]) --> stack_row(R).

stack_row([H|T]) --> item(H), " ", stack_row(T).
stack_row([I]) --> item(I).

item(I) --> "[", [I], "]".
item(nil) --> "   ".

stack_numbers --> stack_number, " ", stack_numbers.
stack_numbers --> stack_number.

stack_number --> " ", digit(_), " ".  % assuming no more than 9 stacks

directions(In, Out) --> command(N, From, To), "\n", {execute(In, N, From, To, Next)}, directions(Next, Out).
directions(In, Out) --> command(N, From, To), {execute(In, N, From, To, Out)}.

command(N, From, To) --> "move ", digits(X), " from ", [Y], " to ", [Z],
{
    number_codes(N, X),
    number_codes(From, [Y]),
    number_codes(To, [Z])
}.

execute(In, N, From, To, Out) :-
    nth1(From, In, FF),
    nth1(To, In, TT),
    append(FH_R, NextFF, FF),
    length(FH_R, N),
    reverse(FH_R, FH),  % remove reversing for part 2
    append(FH, TT, NextTT),
    replace(From, In, NextFF, Temp),
    replace(To, Temp, NextTT, Out).
    
replace(I, L, E, K) :-
    nth1(I, L, _, R),
    nth1(I, K, E, R).
