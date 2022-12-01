solution(F, X) :-
    file_lines(F, Lines),
    phrase(most_calories(X), Lines).

file_lines(File, Lines) :-
    setup_call_cleanup(open(File, read, In),
       stream_lines(In, Lines),
       close(In)).

stream_lines(In, Lines) :-
    read_string(In, _, Str),
    split_string(Str, "\n", "", Lines).

most_calories(Z) --> elf(X), [""], most_calories(Y), {Z is max(X, Y)}.
most_calories(X) --> elf(X).

elf(Z) --> food(X), elf(Y), {Z is X + Y}.
elf(0) --> [].

food(Y) --> [X], {number_string(Y, X)}.
