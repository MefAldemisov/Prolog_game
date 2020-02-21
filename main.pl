/*Some euristics: Step_id [1;4], Pass_id [11; 18]*/
:- use_module(library(clpfd)).
:- style_check(-singleton).
%library(lists). library(random),
t(1, 2).
orc(2, 1).
correct.
human(2, 4).

human(1, 9).
human(3, 0).
human(0, 2).
human(0, 3).
human(5, 5).
human(10, 10).
human(9, 9).
human(10, 9).
human(8, 11).
human(7, 7).
human(0, 7).
human(2, 7).
human(3, 6).


clone_list([],[]).
clone_list([H|T],[H|Z]):- clone_list(T,Z).

check_border(1, X, Y, X_new, Y_new) :- Y_new is Y + 1, Y_new < 20, X_new is X.
check_border(2, X, Y, X_new, Y_new) :- X_new is X + 1, X_new < 20, Y_new is Y.
check_border(3, X, Y, X_new, Y_new) :- Y_new is Y - 1, Y_new >= 0, X_new is X.
check_border(4, X, Y, X_new, Y_new) :- X_new is X - 1, X_new >= 0, Y_new is Y.

no_orc(X_new, Y_new) :- \+ orc(X_new, Y_new).

look_around(Step, X, Y, Check_orcs) :-
    /**
     * (X, Y) - initial coordinates
     * Step is:
     * 1 - Up, 2 - Right, 3 - Down, 4 - Left  */
    check_border(Step, X, Y, X_new, Y_new),
    (Check_orcs is 1 -> no_orc(X_new, Y_new); correct).

test_look_around :-
    look_around(1, 0, 0, 1), look_around(2, 0, 0, 1), \+ look_around(3, 0, 0, 1), \+ look_around(4, 0, 0, 1),  
    \+look_around(1, 0, 19, 1), look_around(2, 0, 19, 1), look_around(3, 0, 19, 1), \+look_around(4, 0, 19, 1),
    look_around(1, 19, 0, 1), \+look_around(2, 19, 0, 1), \+look_around(3, 19, 0, 1), look_around(4, 19, 0, 1),
    \+ look_around(1, 19, 19, 1), \+ look_around(2, 19, 19, 1), look_around(3, 19, 19, 1), look_around(4, 19, 19, 1),
    look_around(1, 1, 1, 1), \+ look_around(2, 1, 1, 1), look_around(3, 1, 1, 1), look_around(4, 1, 1, 1),  
    look_around(1, 10, 4, 1), look_around(2, 10, 4, 1), look_around(3, 10, 4, 1), look_around(4, 10, 4, 1).

appropriate_pass_id(X, Y, 11) :- look_around(1, X, Y, 0).
appropriate_pass_id(X, Y, 12) :- look_around(1, X, Y, 0), look_around(2, X, Y, 0).
appropriate_pass_id(X, Y, 13) :- look_around(2, X, Y, 0).
appropriate_pass_id(X, Y, 14) :- look_around(2, X, Y, 0), look_around(3, X, Y, 0).
appropriate_pass_id(X, Y, 15) :- look_around(3, X, Y, 0).
appropriate_pass_id(X, Y, 16) :- look_around(3, X, Y, 0), look_around(4, X, Y, 0).
appropriate_pass_id(X, Y, 17) :- look_around(4, X, Y, 0).
appropriate_pass_id(X, Y, 18) :- look_around(4, X, Y, 0), look_around(1, X, Y, 0).
    
generate_appropriate_pass_id(X, Y, P) :-

    /**
     * Resulted_step is: 
     * 11 - up, 12 - upper-right, 13 - right
     * 14 - lower-riht, 15 - down, 16 - lower-left, 
     * 17 - left, 18 - upper - left
     */

    findall(S, appropriate_pass_id(X, Y, S), L), 
    random_member(P, L).

generate_appropriate_step_id(X, Y, Can_pass, Step_id) :-
    
    /**
     * (X, Y) - current coordinates
     * Can_pass is 1 -> can pass else - cannot
     * Step_id - return value
     */
    
	findall(S, look_around(S, 0, 0, 1), List_of_steps),
    (Can_pass is 1 -> append(List_of_steps, [5], List_of_all)),
    random_member(Step, List_of_all),
    (Step is 5 -> 
    	generate_appropriate_pass_id(X, Y, Step_id); 
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
    X_n >= 0, Y_n >= 0, X_n < 20, Y_n < 20, \+ orc(X_n, Y_n),
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
        Total_score is Score);
    (generate_appropriate_step_id(X, Y, Can_pass, Step_id),
    % somethin else
    (Step_id > 4 -> make_pass(Step_id, X, Y, X_new, Y_new);
    make_step(Step_id, X, Y, X_new, Y_new)), 
    update_path(X_new, Y_new, Step_id, Path, New_path),
    (Step_id > 4 -> New_can_pass is 0; New_can_pass is Can_pass),
    (human(X_new, Y_new) -> New_score is Score; New_score is Score + 1),
    find_path(X_new, Y_new, New_can_pass, New_path, New_score, Total_path, Total_score)). 


new_best_score(A, B, C, A_path, B_path, C_path) :- 
    format("Best: ~d ~d", [A, B] ),
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

random_path(100, Score, Best, Path) :-
    format("\n\nTotal score is ~w", [Score]),
    writeln("\nNew path: " ), printlist(Path),
    Best is Score.

random_path(Itteration, Score, Best, Path) :-
    Itteration < 100,
    format("New ITTERATION ~d \n" , [Itteration]),
    Next_itr is Itteration + 1,
    (find_path(0, 0, 1, [], 0, New_path, New_score)->
            (new_best_score(Score, New_score, Nbs, Path, New_path, Best_path),
            random_path(Next_itr, Nbs, New_best, Best_path), Best is New_best);
        random_path(Next_itr, Score, New_best, Path), Best is New_best).
