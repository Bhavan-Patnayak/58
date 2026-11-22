:- consult('../code/58_q2.pl').

:- begin_tests(q2).

% Test evaluation of a single number.
test(eval_single_number) :-
    once(expr_eval([7], Tree, Val)),
    assertion(Tree == num(7)),
    assertion(Val =:= 7).

% Test exact division and division by zero.
test(eval_exact_division_and_zero_guard) :-
    findall(V, expr_eval([6, 2], _, V), ValsExact),
    assertion(member(3, ValsExact)),
    \+ expr_eval([5, 2], expr('/', _, _), _),
    \+ expr_eval([4, 0], expr('/', _, _), _).

% Test operator precedence and associativity formatting.
test(expr_to_string_precedence_and_assoc) :-
    once(expr_to_string(
        expr('+', num(1), expr('*', num(2), num(3))),
        S1
    )),
    assertion(S1 == "1+2*3"),

    once(expr_to_string(
        expr('*', expr('+', num(1), num(2)), num(3)),
        S2
    )),
    assertion(S2 == "(1+2)*3"),

    once(expr_to_string(
        expr('-', num(10), expr('-', num(5), num(2))),
        S3
    )),
    assertion(S3 == "10-(5-2)"),

    once(expr_to_string(
        expr('/', num(20), expr('/', num(10), num(2))),
        S4
    )),
    assertion(S4 == "20/(10/2)").

% Test generation of valid equations.
test(generate_equation_basic) :-
    findall(Eq, generate_equation([2, 3, 5], Eq), Eqs),
    assertion(Eqs \= []),
    assertion(forall(member(E, Eqs), string(E))).

% Test empty and single-element input lists.
test(edge_case_short_lists) :-
    \+ generate_equation([], _),
    \+ generate_equation([4], _),

    all_equations([4], Eqs),
    count_equations([4], Cnt),

    assertion(Eqs == []),
    assertion(Cnt =:= 0).

% Test that all_equations returns sorted, unique results
% and count_equations returns the correct count.
test(all_and_count_equations_consistency) :-
    all_equations([1, 2, 3], Eqs),
    count_equations([1, 2, 3], Cnt),

    sort(Eqs, SortedUnique),
    length(SortedUnique, ExpectedLen),

    assertion(Eqs == SortedUnique),
    assertion(Cnt =:= ExpectedLen).

% Test right-child parentheses for equal precedence.
test(expr_to_string_right_same_precedence) :-
    once(expr_to_string(
        expr('+', num(1), expr('+', num(2), num(3))),
        S
    )),
    assertion(S == "1+(2+3)").

% Official example: seven valid equations.
test(assignment_example_seven_equations) :-
    all_equations([4, 2, 5, 3], Eqs),

    Expected = [
        "4*2-5=3",
        "4*2=5+3",
        "4-2=5-3",
        "4/2=5-3",
        "4=2*(5-3)",
        "4=2+(5-3)",
        "4=2+5-3"
    ],

    assertion(Eqs == Expected).

% Official example: no valid equations.
test(assignment_example_no_equations) :-
    \+ generate_equation([2, 3, 4], _),

    all_equations([2, 3, 4], Eqs),

    assertion(Eqs == []).

% Official example: exactly one valid equation.
test(assignment_example_single_equation) :-
    all_equations([2, 4, 8], Eqs),

    assertion(Eqs == ["2*4=8"]),

    count_equations([2, 4, 8], N),
    assertion(N =:= 1).

% Test that negative intermediate expression values are allowed.
test(negative_intermediate_values) :-
    once(expr_eval([3, 5], expr('-', num(3), num(5)), V)),
    assertion(V =:= -2).

% Test that division by zero is rejected inside a nested expression.
test(nested_division_by_zero) :-
    \+ expr_eval(
        [1, 2, 0],
        expr('+', num(1), expr('/', num(2), num(0))),
        _
    ).

% Test that exact division is allowed inside a nested expression.
test(nested_exact_division) :-
    once(expr_eval(
        [1, 8, 2],
        expr('+', num(1), expr('/', num(8), num(2))),
        V
    )),
    assertion(V =:= 5).

% Test that an empty input list produces no equations.
test(empty_list_equations) :-
    all_equations([], Eqs),
    count_equations([], N),
    assertion(Eqs == []),
    assertion(N =:= 0).

:- end_tests(q2).