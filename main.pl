:- use_module(library(clpfd)).
% :- style_check(-singleton).
:- include(tests/test2).
:- (discontiguous orc/2).
:- (discontiguous human/2).
:- (discontiguous t/2).

vision(2).
correct.

t(-1, -1).
human(-1, -1).
orc(-1, -1).

clone_list([], []).
clone_list([H|T],[H|Z]):- clone_list(T,Z).

in_list(X, [X|_]).
in_list(X, [_|L]):- in_list(X, L).

not_in_list(X, Y, Path) :- \+ in_list([X, Y], Path), \+ in_list(['P', X, Y], Path).


in_range(A) :- A >= 0, A < 6.

check_border(1, X, Y, X_new, Y_new) :- Y_new is Y + 1, in_range(Y_new), X_new is X.
check_border(2, X, Y, X_new, Y_new) :- X_new is X + 1, in_range(X_new), Y_new is Y.
check_border(3, X, Y, X_new, Y_new) :- Y_new is Y - 1, in_range(Y_new), X_new is X.
check_border(4, X, Y, X_new, Y_new) :- X_new is X - 1, in_range(X_new), Y_new is Y.

no_orc(X_new, Y_new) :- \+ orc(X_new, Y_new).

look_around(Step, X, Y, Check_orcs) :-
    /**
     * (X, Y) - initial coordinates
     * Step is:
     * 1 - Up, 2 - Right, 3 - Down, 4 - Left  */
    check_border(Step, X, Y, X_new, Y_new),
    (Check_orcs is 1 -> no_orc(X_new, Y_new); correct).

% test_look_around :-
%     look_around(1, 0, 0, 1), look_around(2, 0, 0, 1), \+ look_around(3, 0, 0, 1), \+ look_around(4, 0, 0, 1),  
%     \+look_around(1, 0, 19, 1), look_around(2, 0, 19, 1), look_around(3, 0, 19, 1), \+look_around(4, 0, 19, 1),
%     look_around(1, 19, 0, 1), \+look_around(2, 19, 0, 1), \+look_around(3, 19, 0, 1), look_around(4, 19, 0, 1),
%     \+ look_around(1, 19, 19, 1), \+ look_around(2, 19, 19, 1), look_around(3, 19, 19, 1), look_around(4, 19, 19, 1),
%     look_around(1, 1, 1, 1), \+ look_around(2, 1, 1, 1), look_around(3, 1, 1, 1), look_around(4, 1, 1, 1),  
%     look_around(1, 10, 4, 1), look_around(2, 10, 4, 1), look_around(3, 10, 4, 1), look_around(4, 10, 4, 1).


check_close_touchdown1(X, Y, 1) :- Y_new is Y + 1, t(X, Y_new).
check_close_touchdown1(X, Y, 2) :- X_new is X + 1, t(X_new, Y).
check_close_touchdown1(X, Y, 3) :- Y_new is Y - 1, t(X, Y_new).
check_close_touchdown1(X, Y, 4) :- X_new is X - 1, t(X_new, Y).

% loook 2

check_close_touchdown2(X, Y, 1) :- Y_new is Y + 1, t(X, Y_new).
check_close_touchdown2(X, Y, 2) :- X_new is X + 1, t(X_new, Y).
check_close_touchdown2(X, Y, 3) :- Y_new is Y - 1, t(X, Y_new).
check_close_touchdown2(X, Y, 4) :- X_new is X - 1, t(X_new, Y).
check_close_touchdown2(X, Y, 1) :- Y_new is Y + 2, t(X, Y_new).
check_close_touchdown2(X, Y, 2) :- X_new is X + 2, t(X_new, Y).
check_close_touchdown2(X, Y, 3) :- Y_new is Y - 2, t(X, Y_new).
check_close_touchdown2(X, Y, 4) :- X_new is X - 2, t(X_new, Y).

check_close_touchdown(X, Y, N) :-
    vision(V), 
    (V is 1 -> 
        check_close_touchdown1(X, Y, N);
        check_close_touchdown2(X, Y, N)
    ).

% look 1
appropriate_pass_id1(X, Y, 11) :- look_around(1, X, Y, 0).
appropriate_pass_id1(X, Y, 12) :- look_around(1, X, Y, 0), look_around(2, X, Y, 0).
appropriate_pass_id1(X, Y, 13) :- look_around(2, X, Y, 0).
appropriate_pass_id1(X, Y, 14) :- look_around(2, X, Y, 0), look_around(3, X, Y, 0).
appropriate_pass_id1(X, Y, 15) :- look_around(3, X, Y, 0).
appropriate_pass_id1(X, Y, 16) :- look_around(3, X, Y, 0), look_around(4, X, Y, 0).
appropriate_pass_id1(X, Y, 17) :- look_around(4, X, Y, 0).
appropriate_pass_id1(X, Y, 18) :- look_around(4, X, Y, 0), look_around(1, X, Y, 0).

% look 2
appropriate_pass_id2(X, Y, 11) :- 
    look_around(1, X, Y, 1), 
    Y_n is Y + 1, 
    look_around(1, X, Y_n, 1).

appropriate_pass_id2(X, Y, 12) :- look_around(1, X, Y, 0), look_around(2, X, Y, 0).

appropriate_pass_id2(X, Y, 13) :-
    look_around(2, X, Y, 1), 
    X_n is X + 1, 
    look_around(2, X_n, Y, 1).

appropriate_pass_id2(X, Y, 14) :- look_around(2, X, Y, 0), look_around(3, X, Y, 0).

appropriate_pass_id2(X, Y, 15) :- 
    look_around(3, X, Y, 1),
    Y_n is Y - 1, 
    look_around(3, X, Y_n, 1).

appropriate_pass_id2(X, Y, 16) :- look_around(3, X, Y, 0), look_around(4, X, Y, 0).

appropriate_pass_id2(X, Y, 17) :- 
    look_around(4, X, Y, 1),
    X_n is X - 1, 
    look_around(4, X_n, Y, 1).

appropriate_pass_id2(X, Y, 18) :- look_around(4, X, Y, 0), look_around(1, X, Y, 0).

appropriate_pass_id(X, Y, N) :-
    vision(V),
    (V is 1 -> 
        appropriate_pass_id1(X, Y, N);
        appropriate_pass_id2(X, Y, N)).

generate_appropriate_pass_id(X, Y, P) :-

    /**
     * Resulted_step is: 
     * 11 - up, 12 - upper-right, 13 - right
     * 14 - lower-riht, 15 - down, 16 - lower-left, 
     * 17 - left, 18 - upper - left
     */

    findall(S, appropriate_pass_id(X, Y, S), L), 
    random_member(P, L).

generate_random_appropriate_step_id(X, Y, Can_pass, Step_id) :-
    
    /**
     * (X, Y) - current coordinates
     * Can_pass is 1 -> can pass else - cannot
     * Step_id - return value
     */
    findall(S, look_around(S, X, Y, 1), List_of_steps),
    (Can_pass is 1 -> append(List_of_steps, [5], List_of_all); clone_list(List_of_steps, List_of_all)),
    random_member(Step, List_of_all),
    (Step is 5 -> 
    	generate_appropriate_pass_id(X, Y, Step_id); 
    	Step_id is Step).

generate_appropriate_step_id(X, Y, Can_pass, Step_id) :-

    /**
     * (X, Y) - current coordinates
     * Can_pass is 1 -> can pass else - cannot
     * Step_id - return value
     */
    findall(S, look_around(S, X, Y, 1), List_of_steps),
    (Can_pass is 1 -> append(List_of_steps, [5], List_of_all); clone_list(List_of_steps, List_of_all)),
    member(Step, List_of_all),
    (Step is 5 -> 
        appropriate_pass_id(X, Y, Step_id); 
        Step_id is Step).
    

make_step(Step_id, X, Y, X_new, Y_new) :- check_border(Step_id, X, Y, X_new, Y_new).

search_human(X, Y, Step_x, Step_y, X_new, Y_new) :-
    /**
     * Make attempt to go one step further in the direction of a target
     * (X, Y) - initial position
     * (Stp_x, Step_y) - how does coordinate changes (direction)
     * (X_new, Y_new) - where have you come
     */

    X_n is X + Step_x,
    Y_n is Y + Step_y,
    in_range(X_n), in_range(Y_n), no_orc(X_n, Y_n),
    (   human(X_n, Y_n) ->  
    (   X_new is X_n, 
    	Y_new is Y_n);
    search_human(X_n, Y_n, Step_x, Step_y, X_new, Y_new)). 

make_pass(11, X, Y, X_new, Y_new) :- search_human(X, Y, 0, 1, X_new, Y_new).
make_pass(12, X, Y, X_new, Y_new) :- search_human(X, Y, 1, 1, X_new, Y_new).
make_pass(13, X, Y, X_new, Y_new) :- search_human(X, Y, 1, 0, X_new, Y_new).
make_pass(14, X, Y, X_new, Y_new) :- search_human(X, Y, 1, -1, X_new, Y_new).
make_pass(15, X, Y, X_new, Y_new) :- search_human(X, Y, 0, -1, X_new, Y_new).
make_pass(16, X, Y, X_new, Y_new) :- search_human(X, Y, -1, -1, X_new, Y_new).
make_pass(17, X, Y, X_new, Y_new) :- search_human(X, Y, -1, 0, X_new, Y_new).
make_pass(18, X, Y, X_new, Y_new) :- search_human(X, Y, -1, 1, X_new, Y_new).

update_path(X_new, Y_new, Step_id, Path, New_path) :-

    /**
     * Updates the list with the pass
     */

    Step_id < 5 ->
    append(Path, [[X_new, Y_new]], New_path);
    append(Path, [["P", X_new, Y_new]], New_path).

find_path(X, Y, Can_pass, Path, Score, Total_path, Total_score) :-

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
        Total_score is Score, !);
    (   
    (check_close_touchdown(X, Y, Step_id) -> correct;
        generate_random_appropriate_step_id(X, Y, Can_pass, Step_id)
    ),
    % somethin else
    (Step_id > 4 -> make_pass(Step_id, X, Y, X_new, Y_new);
    make_step(Step_id, X, Y, X_new, Y_new)),
    not_in_list(X_new, Y_new, Path),
    update_path(X_new, Y_new, Step_id, Path, New_path),
    (Step_id > 4 -> New_can_pass is 0; New_can_pass is Can_pass),
    (human(X_new, Y_new) -> New_score is Score; New_score is Score + 1),
    find_path(X_new, Y_new, New_can_pass, New_path, New_score, Total_path, Total_score)). 


new_best_score(A, B, C, A_path, B_path, C_path) :- 
    A < B -> C is A, clone_list(A_path, C_path);
    C is B, clone_list(B_path, C_path).


% print items separated by spaces
print_list_item([]).

print_list_item([X|List]) :-
    format("~w ", [X]),
    print_list_item(List).
    
% print list line by line
printlist([]).
    
printlist([X|List]) :-
    print_list_item(X), nl,
    printlist(List).

% find the list(path) + length which is the shortest

list_min([[_, S]|Ls], Min) :-
    list_min(Ls, S, Min).

list_min([], Min, Min).

list_min([[_, S]|Ls], Min0, Min) :-
    Min1 is min(S, Min0),
    list_min(Ls, Min1, Min).

% find the shortest path
get_path_with_min(_, _, []) :-
    fail.
get_path_with_min(P, M, [[A, B]|L]) :-
    (   M is B ->   
    	clone_list(P,A);
    	get_path_with_min(P, M, L)).

% ramdom search

random_path(100, Score, Best, Path) :-
    (Score < 100 ->
    (format("Total score is ~w", [Score]),
    writeln("\nNew path: " ), printlist(Path));
    writeln("Not sucseed")),
    Best is Score.

random_path(Itteration, Score, Best, Path) :-
    Itteration < 100,
    Next_itr is Itteration + 1,
    (find_path(0, 0, 1, [], 0, New_path, New_score)->
            (new_best_score(Score, New_score, Nbs, Path, New_path, Best_path),
            random_path(Next_itr, Nbs, New_best, Best_path), Best is New_best);
        random_path(Next_itr, Score, New_best, Path), Best is New_best).
