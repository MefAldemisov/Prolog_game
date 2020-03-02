:- [main, tree, backtracking_tree].
:- use_module(library(statistics)).

go :-
    statistics(walltime, [TimeSinceStart | [TimeSinceLastCall]]),
    random_path(0, 100000, B, P),
    statistics(walltime, [NewTimeSinceStart | [ExecutionTime]]),
    write('Execution took '), write(ExecutionTime), write(' ms.'), nl.
