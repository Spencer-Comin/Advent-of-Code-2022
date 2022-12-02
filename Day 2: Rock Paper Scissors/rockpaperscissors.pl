solution(F, X) :-
    file_lines(F, Lines),
    maplist(points, Lines, Points),
    sum_list(Points, X).

file_lines(File, Lines) :-
    setup_call_cleanup(open(File, read, In),
       stream_lines(In, Lines),
       close(In)).

stream_lines(In, Lines) :-
    read_string(In, _, Str),
    split_string(Str, "\n", "", Lines).

points("A X", 1+3).
points("A Y", 2+6).
points("A Z", 3+0).
points("B X", 1+0).
points("B Y", 2+3).
points("B Z", 3+6).
points("C X", 1+6).
points("C Y", 2+0).
points("C Z", 3+3).
