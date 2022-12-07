:- use_module(library(clpfd)).

solution(F, X, Y) :-
    file_codes(F, C),
    marker_index(C, X),
    message_index(C, Y).

file_codes(F, S) :-
    setup_call_cleanup(open(F, read, In),
       read_stream_to_codes(In, S),
       close(In)).

marker_index([A, B, C, D|_], 4) :- all_distinct([A, B, C, D]).
marker_index([_|T], Y) :- marker_index(T, X), Y is X + 1.

message_index([A, B, C, D, E, F, G, H, I, J, K, L, M, N|_], 14) :- all_distinct([A, B, C, D, E, F, G, H, I, J, K, L, M, N]).
message_index([_|T], Y) :- message_index(T, X), Y is X + 1.
