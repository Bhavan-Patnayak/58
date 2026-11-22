:- use_module(library(lists)).

split_nonempty(List, Left, Right) :-
    append(Left, Right, List),
    Left = [_ | _],
    Right = [_ | _].

expr_eval([N], num(N), N) :-
    integer(N),
    N >= 0.

expr_eval(Nums, expr(Op, LTree, RTree), Val) :-
    split_nonempty(Nums, LNums, RNums),
    expr_eval(LNums, LTree, LVal),
    expr_eval(RNums, RTree, RVal),
    apply_op(Op, LVal, RVal, Val).

apply_op('+', A, B, V) :- V is A + B.
apply_op('-', A, B, V) :- V is A - B.
apply_op('*', A, B, V) :- V is A * B.
apply_op('/', A, B, V) :-
    B =\= 0,
    0 =:= A mod B,
    V is A div B.

op_prec('+', 1).
op_prec('-', 1).
op_prec('*', 2).
op_prec('/', 2).

need_parens_left(_, num(_), false).
need_parens_left(ParentOp, expr(ChildOp, _, _), Need) :-
    op_prec(ParentOp, PParent),
    op_prec(ChildOp, PChild),
    (PChild < PParent -> Need = true ; Need = false).

need_parens_right(_, num(_), false).
need_parens_right(ParentOp, expr(ChildOp, _, _), Need) :-
    op_prec(ParentOp, PParent),
    op_prec(ChildOp, PChild),
    (PChild =< PParent -> Need = true ; Need = false).

expr_to_string(num(N), Str) :-
    number_string(N, Str).

expr_to_string(expr(Op, LTree, RTree), Str) :-
    expr_to_string(LTree, LRaw),
    expr_to_string(RTree, RRaw),
    need_parens_left(Op, LTree, LParens),
    need_parens_right(Op, RTree, RParens),
    wrap_parens(LParens, LRaw, LStr),
    wrap_parens(RParens, RRaw, RStr),
    atom_string(Op, OpStr),
    string_concat(LStr, OpStr, T1),
    string_concat(T1, RStr, Str).

wrap_parens(false, S, S).
wrap_parens(true, S, Out) :-
    string_concat("(", S, T),
    string_concat(T, ")", Out).

generate_equation(Nums, Eq) :-
    split_nonempty(Nums, LNums, RNums),
    expr_eval(LNums, LTree, Val),
    expr_eval(RNums, RTree, Val),
    expr_to_string(LTree, LStr),
    expr_to_string(RTree, RStr),
    string_concat(LStr, "=", T1),
    string_concat(T1, RStr, Eq).

all_equations(Nums, Eqs) :-
    findall(Eq, generate_equation(Nums, Eq), RawEqs),
    sort(RawEqs, Eqs).

count_equations(Nums, Count) :-
    all_equations(Nums, Eqs),
    length(Eqs, Count).