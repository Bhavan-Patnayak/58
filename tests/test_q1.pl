% Test suite for Problem 1 (P1).
% Run from the repository root:
%   swipl -q -s tests/test_q1.pl -g run_tests -t halt

:- dynamic q1_loaded/0.

load_q1 :-
    (   q1_loaded -> true
    ;   prolog_load_context(directory, TestDir),
        atomic_list_concat([TestDir, '/../code/58_q1.pl'], Target),
        consult(Target),
        assertz(q1_loaded)
    ).

:- load_q1.

:- begin_tests(q1).

% P1.a: main/0 prints four lines in "Name = [Dept, Lang, Project]" format
% for a valid solution to clues 1..8.
test(main_output_format) :-
    with_output_to(string(Out), main),
    split_string(Out, "\n", "\r", LinesWithEmpty),
    exclude(=(""), LinesWithEmpty, Lines),
    assertion(length(Lines, 4)),
    Lines = [L1, L2, L3, L4],
    assertion(sub_string(L1, 0, 7, _, "Alex = ")),
    assertion(sub_string(L2, 0, 6, _, "Ben = ")),
    assertion(sub_string(L3, 0, 8, _, "Carla = ")),
    assertion(sub_string(L4, 0, 7, _, "Dana = ")).

% P1.b: 4! * 4! * 4! = 13,824 total candidate assignments when no clues are active.
test(all_candidate_assignments) :-
    count_solutions([], N),
    assertion(N =:= 13824).

% P1.b: count_solutions/2 ignores clues outside Active (1/4 of 13824 = 3456).
test(single_clue_subset) :-
    count_solutions([9], N),
    assertion(N =:= 3456).

% P1.b: Clues 1 through 8 leave exactly three valid assignments.
test(first_eight_clues) :-
    count_solutions([1,2,3,4,5,6,7,8], N),
    assertion(N =:= 3).

% P1.c: Adding clue 9 narrows the valid assignments to exactly one.
test(all_nine_clues) :-
    count_solutions([1,2,3,4,5,6,7,8,9], N),
    assertion(N =:= 1).

% P1.c: Verify the unique assignment selected by clues 1 through 9.
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

% P1.c: Clue 9 holds for the target solution and fails on the other two solutions of 1..8.
test(clue_9_discriminates_among_solutions_1_to_8) :-
    findall(Sol, (solution(Sol), valid_for_clues([1,2,3,4,5,6,7,8], Sol)), Sols),
    include(clue(9), Sols, Passing),
    exclude(clue(9), Sols, Failing),
    assertion(length(Passing, 1)),
    assertion(length(Failing, 2)).

% Every clue from 1 through 9 succeeds on the unique assignment.
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