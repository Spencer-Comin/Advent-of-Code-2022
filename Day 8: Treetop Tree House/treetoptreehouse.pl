solution(F, X) :-
    file_lines(F, Map),
    aggregate_all(count, Pos, (is_intersection(Map, Pos, E, U, D, L, R), is_visible(E, U, D, L, R)), X).

file_lines(File, Lines) :-
    setup_call_cleanup(open(File, read, In),
       stream_lines(In, Lines),
       close(In)).

stream_lines(In, Codes) :-
    read_string(In, _, Str),
    split_string(Str, "\n", "", Lines),
    maplist(string_codes, Lines, Codes).

is_visible(X, U, D, L, R) :-
    maplist(>(X), U);
    maplist(>(X), D);
    maplist(>(X), L);
    maplist(>(X), R).

is_intersection(Map, (ColumnIndex, RowIndex), X, U, D, L, R) :-
    nth0(RowIndex, Map, Row),
    maplist(nth0(ColumnIndex), Map, Column),
    index_before_after(Column, RowIndex, X, U, D),
    index_before_after(Row, ColumnIndex, X, L, R).

index_before_after(L, I, E, B, A) :-
    append(B, [E|A], L),
    length(B, I).
