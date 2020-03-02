:- use_module(library(clpfd)).
:- style_check(-singleton).
:- [main].

tree_path(Best_score, Path) :-
    findall([New_path, New_score], find_path(0, 0, 1, [], 0, New_path, New_score, 0), Results),
    list_min(Results, Min),
    get_path_with_min(Path, Min, Results),
    format("Total score is ~w", [Min]),
    writeln("\nNew path: " ), printlist(Path).
