---
name: prolog-dev
description: Conventions, run/test commands, self-review checklist and known failure modes for writing SWI-Prolog 9.x code for CS F301 Assignment 2 (P1 puzzle, P2 equations).
---

# Prolog Development Skill (`prolog-dev`)

## Environment and language
- **Language and version:** SWI-Prolog 9.x.
- **Target files:** `code/58_q1.pl` (P1) and `code/58_q2.pl` (P2). They contain only definitions: no `initialization` directive, no `halt/0`, nothing printed on load.
- **Allowed libraries only:** `lists`, `apply`, `yall`, `aggregate`. No `clpfd`, no `dcg/basics`, no others.

## Coding conventions
- **Naming:** `snake_case` for predicates, functors and atoms; `PascalCase` for variables.
- **Comments:** every predicate has a header comment giving its mode (`+`, `-`, `?`) and a short *declarative reading* (what holds when it succeeds), plus a note on termination where it is not obvious.
- **Purity:** no `assert*`, `retract*`, `b_setval/2` or `nb_setval/2`. Pass state through arguments.
- **No string evaluation:** never build a string or atom and parse it back into a term to evaluate it (P2).
- **Output:** print only what the task specifies. No debug `write` or `format` left in.
- **Values:** use exactly the atoms from the spec, quoted where needed: `'Alex'`, `'c++'`, `'AI'`.

## Running and testing
Run `main/0` (from the repository root, PowerShell; use `/` on Bash):
```
swipl -q -f code\58_q1.pl -g main -t halt
```
Run any other goal:
```
swipl -q -f code\58_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8],N),write(N),nl" -t halt
swipl -q -f code\58_q2.pl -g "all_equations([4,2,5,3],Es),print(Es),nl" -t halt
```
Expected values to check against:
- P1: N = 3 for clues 1 to 8, N = 1 for clues 1 to 9.
- P2: `[4,2,5,3]` gives 7 equations, `[2,4,8]` gives `["2*4=8"]`, `[2,3,4]` gives `[]`, and `generate_equation` fails for `[]`, `[5]` and `[2,3,4]`.

Run the tests in `tests/` the same way, and always load the file with `-f` exactly as the grader does.

## Self-review checklist (apply before answering)
1. Loading the file prints nothing and gives no warnings (singletons, discontiguous clauses).
2. Only allowed libraries are loaded.
3. No `assert`, `retract`, global variables, `halt/0` or `initialization`.
4. Each predicate has a header comment with mode and declarative reading.
5. Output format matches the spec character for character (spacing, quoting, order).
6. Every example in the PDF passes as a test.
7. Edge cases are covered: empty list, one-element list, zero, negative intermediate values, no solution.
8. Failure cases fail cleanly: no loop, no error, no leftover output.
9. No predicate loops on backtracking (check with `findall` over the whole search space).
10. Counting predicates do not overcount (see failure modes).
11. P1: `clue(9, ...)` has the `% CLUE 9:` comment on the line directly above it and mentions no friend by name.
12. P2: results are SWI strings (not atoms or code lists), sorted with `sort/2`, no duplicates.

## Known AI failure modes for Prolog
- **Forbidden libraries.** Reaching for `clpfd` (`#=`, `all_different`) because it is the usual way to solve puzzles.
- **Wrong text type.** Returning atoms or code lists where an SWI string is required (P2). Check with `string(E)`.
- **Quoting.** Writing `c++` or `AI` unquoted, or using `'ai'` instead of `'AI'`.
- **Overcounting.** A clue that can succeed twice on the same solution makes `aggregate_all(count, ...)` count it twice. Use `once/1` or make the clue deterministic.
- **Inexact or unsafe division.** Using `/` or `//` instead of an exact check (`B =\= 0`, `0 =:= A mod B`), or checking only the top-level division and not every sub-expression.
- **Parenthesis rule errors.** Getting left versus right associativity wrong (`1-(2-3)` versus `1-2-3`, `8/(4*2)` versus `8/4*2`), which merges or splits distinct trees.
- **Printing in the wrong place.** Leaving `print`, `write` or `format` calls in helper predicates, or printing from `count_solutions`.
- **Calling `halt/0` or adding `:- initialization(main).`** Both are forbidden; the grader supplies `-g` and `-t halt`.
- **Unbounded search.** Left recursion or an unconstrained `append/3` that loops when no solution exists. Fail on lists of length 0 and 1 explicitly through the structure of the search.
- **Hard-coding the answer** to P1 instead of deriving it from the clues.
- **Naming a friend in clue 9**, or writing one that is not false in every other solution of clues 1 to 8.
- **Unsorted or duplicated results** from `all_equations`, by forgetting `sort/2`.
- **Claiming it was tested without running it.** Always run the commands above and report actual output.