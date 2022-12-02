solution(F, X, Y) :-
    file_lines(F, Lines),
    maplist(points1, Lines, Points1),
    sum_list(Points1, X),
    maplist(points2, Lines, Points2),
    sum_list(Points2, Y).

file_lines(File, Lines) :-
    setup_call_cleanup(open(File, read, In),
       stream_lines(In, Lines),
       close(In)).

stream_lines(In, Lines) :-
    read_string(In, _, Str),
    split_string(Str, "\n", "", Lines).

points1("A X", 1+3).
points1("A Y", 2+6).
points1("A Z", 3+0).
points1("B X", 1+0).
points1("B Y", 2+3).
points1("B Z", 3+6).
points1("C X", 1+6).
points1("C Y", 2+0).
points1("C Z", 3+3).

points2("A X", 3+0).
points2("A Y", 1+3).
points2("A Z", 2+6).
points2("B X", 1+0).
points2("B Y", 2+3).
points2("B Z", 3+6).
points2("C X", 2+0).
points2("C Y", 3+3).
points2("C Z", 1+6).
