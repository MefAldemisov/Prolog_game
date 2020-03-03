:- [main, tree, backtracking_tree].
:- use_module(library(statistics)).

go :-
    % random
    statistics(walltime, [TimeSinceStart1 | [TimeSinceLastCall1]]),
    random_path(0, 100000, B, S),
    statistics(walltime, [NewTimeSinceStar | [ExecutionTimeR]]),
    write('Execution of random took '), write(ExecutionTimeR), write(' ms.'), nl,
    % tree
    statistics(walltime, [TimeSinceStart2 | [TimeSinceLastCall2]]),
    tree_path(_, _),
    statistics(walltime, [_ | [ExecutionTimeT]]),
    write('Execution of tree took '), write(ExecutionTimeT), write(' ms.'), nl,
    % backtrack
    backtrack_tree_path(_, _),
    statistics(walltime, [_ | [ExecutionTimeB]]),
    write('Execution of random took '), write(ExecutionTimeR), write(' ms.'), nl,
    write('Execution of tree took '), write(ExecutionTimeT), write(' ms.'), nl,
    write('Execution of backtrack took '), write(ExecutionTimeB), write(' ms.').
