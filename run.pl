:- [main, tree, backtracking_tree].
:- use_module(library(statistics)).

go :-
    % random
    statistics(walltime, [_ | [_]]),
    random_path(0, 100000, _, _),
    statistics(walltime, [_ | [ExecutionTimeR]]),
    write('Execution of random took '), write(ExecutionTimeR), write(' ms.'), nl, 
    % tree
    statistics(walltime, [_ | [_]]),
    tree_path(_, _),
    statistics(walltime, [_ | [ExecutionTimeT]]),
    write('Execution of tree took '), write(ExecutionTimeT), write(' ms.'), nl,
    % backtrack
    backtrack_tree_path(_, _),
    statistics(walltime, [_ | [ExecutionTimeB]]),
    write('Execution of backtrack took '), write(ExecutionTimeB), write(' ms.').
