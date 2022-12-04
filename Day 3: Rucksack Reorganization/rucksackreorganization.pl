solution(F, X, Y) :-
    file_lines(F, Lines),
    maplist(prioritize, Lines, Priorities),
    sum_list(Priorities, X),
    phrase(badge_priorities(Y), Lines).

file_lines(File, Lines) :-
    setup_call_cleanup(open(File, read, In),
       stream_lines(In, Lines),
       close(In)).

stream_lines(In, Lines) :-
    read_string(In, _, Str),
    split_string(Str, "\n", "", Lines).

prioritize(Line, Priority) :-
    string_codes(Line, Codes),
    maplist(adjust, Codes, Priorities),
    append(Compartment1, Compartment2, Priorities),
    length(Compartment1, L), length(Compartment2, L),
    list_to_ord_set(Compartment1, Set1), list_to_ord_set(Compartment2, Set2),
    ord_intersection(Set1, Set2, Intersection),
    sum_list(Intersection, Priority).

adjust(Code, Priority) :-
    Code >= 0'a, Code =< 0'z,
    Priority is Code - 0'a + 1.

adjust(Code, Priority) :-
    Code >= 0'A, Code =< 0'Z,
    Priority is Code - 0'A + 27.

badge_priorities(P) --> badge_group(X), badge_priorities(Y), {P is X + Y}.
badge_priorities(P) --> badge_group(P).

badge_group(P) --> rucksack(X), rucksack(Y), rucksack(Z), {ord_intersection([X, Y, Z], I), sum_list(I, P)}.

rucksack(R) --> [S], {string_codes(S, C), maplist(adjust, C, P), list_to_ord_set(P, R)}.
