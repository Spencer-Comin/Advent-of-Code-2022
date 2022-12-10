% use --traditional
:- use_module(library(dcg/basics)).

solution(F, X) :-
    file_codes(F, C),
    phrase(commands(_, [[/]-_], _, DirSizes), C),
    maplist(crunch_size, DirSizes, Sizes),
    exclude(<(100000), Sizes, Smalls),
    sum_list(Smalls, X).

file_codes(F, C) :-
    setup_call_cleanup(open(F, read, In),
       read_stream_to_codes(In, C),
       close(In)).

crunch_size(_-S, Z) :- Z is S.

commands(InPWD, InDirSizes, OutPWD, OutDirSizes) --> command(InPWD, InDirSizes, NextPWD, NextDirSizes), "\n", commands(NextPWD, NextDirSizes, OutPWD, OutDirSizes).
commands(InPWD, InDirSizes, OutPWD, OutDirSizes) --> command(InPWD, InDirSizes, OutPWD, OutDirSizes).

% command(InPWD, InDirSizes, OutPWD, OutDirSizes)
command(_, S, [/], S) --> "$ cd /".
command([_|T], S, T, S) --> "$ cd ..".
command(T, S, [D|T], S) --> "$ cd ", string_without("\n", C), {atom_codes(D, C)}.
command(D, InDirSizes, D, OutDirSizes) --> "$ ls\n", contents(D, InDirSizes, OutDirSizes, SizeofD),
{
    member(D-SizeofD, OutDirSizes)
}.

% contents(D, InDirSizes, OutDirSizes, SizeofD)
contents(D, InDirSizes, OutDirSizes, X+Y) --> item(D, InDirSizes, NextDirSizes, X), "\n", contents(D, NextDirSizes, OutDirSizes, Y).
contents(D, InDirSizes, OutDirSizes, S) --> item(D, InDirSizes, OutDirSizes, S).

% item(D, InDirSizes, OutDirSizes, SizeofD)
item(D, InDirSizes, OutDirSizes, Size) --> "dir ", string_without("\n", DirCodes),
{
    atom_codes(Dir, DirCodes),
    DirSize = [Dir|D]-Size,
    (   member(DirSize, InDirSizes) -> OutDirSizes = InDirSizes
    ;   OutDirSizes = [DirSize|InDirSizes]
    )
}.
item(_, DS, DS, Size) --> digits(SizeCodes), " ", string_without("\n", _), {number_codes(Size, SizeCodes)}.
