:- use_module(library(clpfd)).
:- style_check(-singleton).
:- [main].
:- dynamic local_min/1.
%library(lists). library(random),

find_backtrack_path(X, Y, Can_pass, Path, Score, Total_path, Total_score) :-

    /**
     * Searches randomly for the next step and make it
     * (X, Y) - initial position
     * Can_pass is 1 -> the player haven't yet done any pass,
     * Can_pass is 0 -> no pass can be done
     * Path - list of all previous coordinates
     * Score - the current amount of steps/movements
     * Tota_path - the shortest path (to be returned)
     * Total_score - the smallest score (to be returned)
     */

    t(X, Y) ->
        (clone_list(Path, Total_path), 
        Total_score is Score, local_min(Lm),
        (Lm > Score -> 
            (retractall(local_min(_)), 
            asserta(local_min(Score)), local_min(Nlm), format("Update ~w \n", [Nlm]));
            correct)
        );
    ((check_close_touchdown(X, Y, Step_id) -> correct;
    generate_appropriate_step_id(X, Y, Can_pass, Step_id)),
    % somethin else
    (Step_id > 4 -> make_pass(Step_id, X, Y, X_new, Y_new);
    make_step(Step_id, X, Y, X_new, Y_new)), 
    not_in_list(X_new, Y_new, Path),
    update_path(X_new, Y_new, Step_id, Path, New_path),
    (Step_id > 4 -> New_can_pass is 0; New_can_pass is Can_pass),
    (human(X_new, Y_new) -> New_score is Score; New_score is Score + 1),
    local_min(Lm), Lm >= New_score,
    find_backtrack_path(X_new, Y_new, New_can_pass, New_path, New_score, Total_path, Total_score)). 


backtrack_tree_path(Best_score, Path) :-
    % Itteration < 100,
    % format("New ITTERATION ~d \n" , [Itteration]),
    % Next_itr is Itteration + 1,
    retractall(local_min(_)),
    asserta(local_min(10000)),
    local_min(Lm),
    findall([New_path, New_score], find_backtrack_path(0, 0, 1, [], 0, New_path, New_score), Results) ->
    (list_min(Results, Min)->
    (get_path_with_min(Path, Min, Results),
    format("Total score is ~w", [Min]),
    writeln("\nNew path: " ), printlist(Path));
    writeln("Not sucseed")).