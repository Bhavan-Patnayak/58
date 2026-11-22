% Test suite for Problem 1 (P1).
% Run from the GROUP42 repository root:
%   swipl -q -s tests/test_q1.pl -g run_tests -t halt

:- consult('../code/58_q1.pl').

:- begin_tests(q1).

% The three independent domains each contain four distinct values:
% 4! * 4! * 4! = 13,824 candidate assignments.
test(all_candidate_assignments) :-
    count_solutions([], N),
    assertion(N =:= 13824).

% The first eight clues should leave exactly three valid assignments.
test(first_eight_clues) :-
    count_solutions([1,2,3,4,5,6,7,8], N),
    assertion(N =:= 3).

% Clue 9 should reduce the number of valid assignments to exactly one.
test(all_nine_clues) :-
    count_solutions([1,2,3,4,5,6,7,8,9], N),
    assertion(N =:= 1).

% Check the unique assignment selected by clues 1 through 9.
test(unique_assignment, [nondet]) :-
    once((
        solution(Sol),
        valid_for_clues([1,2,3,4,5,6,7,8,9], Sol)
    )),
    Expected = [
        p('Alex', design, java, embedded),
        p('Ben', development, javascript, web),
        p('Carla', testing, python, 'AI'),
        p('Dana', research, 'c++', data)
    ],
    assertion(Sol == Expected).

% Every clue from 1 through 9 should succeed for the unique assignment.
test(each_clue_holds) :-
    Sol = [
        p('Alex', design, java, embedded),
        p('Ben', development, javascript, web),
        p('Carla', testing, python, 'AI'),
        p('Dana', research, 'c++', data)
    ],
    forall(
        between(1, 9, N),
        (clue(N, Sol) -> true ; assertion(failed_clue(N)))
    ).

:- end_tests(q1).
