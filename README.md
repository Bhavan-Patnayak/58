# POPL_Assignment# CS F301 Principles of Programming Languages: Assignment 2

Logic and Functional Programming (Prolog and Scheme/Racket).

**Group folder:** `GROUP42`  |  **File prefix:** `58` (replace with your assigned group ID if different)

---

## 1. Repository layout

```
GROUP42/
  code/
    58_q1.pl      P1  Department Assignment Puzzle (Prolog)
    58_q2.pl      P2  Valid Arithmetic Equation (Prolog)
    58_q3.rkt     S1  Binary Tree Traversals (Racket)
    58_q4.rkt     S2  Conditional Insert into Nested List (Racket)
  tests/          test files and expected outputs, one set per problem
  skills/
    prolog-dev/SKILL.md
    scheme-dev/SKILL.md
  prompts/        P1.md  P2.md  S1.md  S2.md  (prompts used, word for word)
  P1_REPORT.md    value of N for P1.b and what it tells us
  README.md       this file
```

## 2. Requirements

| Tool | Version | Check with |
|---|---|---|
| SWI-Prolog | 9.x | `swipl --version` |
| Racket | 8.x | `racket --version` |

All commands below are run from the `GROUP42` folder. PowerShell commands are given first; Git Bash, macOS and Linux equivalents follow where they differ.

---

## 3. P1: Department Assignment Puzzle (`code/58_q1.pl`)

### How it works

The program is generate-and-test.

1. **Generate.** `solution/1` builds a list of four terms `p(Name, Dept, Lang, Project)` for Alex, Ben, Carla and Dana, in that order. Each attribute is a `permutation/2` of its four values, so every value is used exactly once. That gives 24 x 24 x 24 = 13,824 candidates.
2. **Test.** Each clue is its own clause `clue(N, Solution)`, which succeeds exactly when clue N holds in a filled-in solution. Clues find friends with `member/2`, by name or by attribute value.
3. **Combine.** `valid_for_clues/2` checks that every clue number in a list holds.

### The three tasks

| Task | Predicate | What it does |
|---|---|---|
| P1.a solve | `main/0` | Takes the first candidate satisfying clues 1 to 8 and prints four lines `Name = [Dept, Lang, Project]`. The answer is derived from the clues, not hard-coded. |
| P1.b count | `count_solutions(Active, N)` | `aggregate_all(count, ...)` over all candidates satisfying exactly the clues in `Active`. For clues 1 to 8, N = 3. |
| P1.c repair | `clue(9, Solution)` | Added clue: the friend in the design department prefers embedded projects. It names no friend, is true in exactly one of the three solutions, and gives N = 1. |

The report for P1.b is in `P1_REPORT.md`.

### How to run

```powershell
# P1.a: print one solution of clues 1 to 8
swipl -q -f code\58_q1.pl -g main -t halt

# P1.b: count solutions of clues 1 to 8 (expected 3)
swipl -q -f code\58_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8],N),write(N),nl" -t halt

# P1.c: count solutions of clues 1 to 9 (expected 1)
swipl -q -f code\58_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8,9],N),write(N),nl" -t halt
```

On Git Bash, macOS or Linux, use `/` instead of `\` in the path.

---

## 4. P2: Valid Arithmetic Equation (`code/58_q2.pl`)

### How it works

Given a list of numbers, the program inserts `+ - * /` and exactly one `=` so that both sides have the same value.

1. **Choose where the `=` goes.** `split_nonempty/3` uses `append/3` backwards to cut the list into a non-empty left and right part. Lists of length 0 or 1 have no such cut, so they fail with no special code.
2. **Build every expression tree.** `expr_eval/3` makes either a leaf `num(N)` or a node `expr(Op, Left, Right)` by splitting the list again and recursing. Backtracking tries every split and every operator. The value is computed while the tree is built, and no string is ever parsed back.
3. **Check division.** `apply_op/4` allows `/` only when the divisor is non-zero and the division is exact. This runs at every node, so an inexact division anywhere discards that branch.
4. **Match the two sides.** `generate_equation/2` evaluates both sides with the same value variable, so only equal-valued pairs succeed.
5. **Print in canonical form.** `expr_to_string/2` turns the tree into an SWI-Prolog string with no spaces:
   - a left operand gets parentheses only if its operator binds looser than its parent's,
   - a right operand gets parentheses if its operator binds the same or looser,
   - so every different tree gives a different string (`1+2+3` versus `1+(2+3)`).
6. **Collect.** `all_equations/2` uses `findall/3` and `sort/2` (removes duplicates, standard order). `count_equations/2` is the length of that list.

### Public predicates

| Predicate | Meaning |
|---|---|
| `generate_equation(List, Eq)` | One valid equation; fails if none exists |
| `all_equations(List, Eqs)` | Sorted list of all valid equations without duplicates, `[]` if none |
| `count_equations(List, N)` | Length of that list |

### How to run

```powershell
swipl -q -f code\58_q2.pl -g "all_equations([4,2,5,3],Es),print(Es),nl" -t halt
swipl -q -f code\58_q2.pl -g "all_equations([2,4,8],Es),print(Es),nl" -t halt
swipl -q -f code\58_q2.pl -g "all_equations([2,3,4],Es),print(Es),nl" -t halt
swipl -q -f code\58_q2.pl -g "(generate_equation([2,3,4],_) -> writeln(found) ; writeln(failed))" -t halt
swipl -q -f code\58_q2.pl -g "count_equations([4,2,5,3],N),writeln(N)" -t halt
```

Expected output:

```
["4*2-5=3","4*2=5+3","4-2=5-3","4/2=5-3","4=2*(5-3)","4=2+(5-3)","4=2+5-3"]
["2*4=8"]
[]
failed
7
```

Also try `[]`, `[5]` (both should fail) and `[0,0]` (should give `["0=0"]`).

---

## 5. S1: Binary Tree Traversals (`code/58_q3.rkt`)

### How it works

A tree is `()` or `(value left right)`. The file only defines functions and prints nothing when loaded.

- **Traversals** use an accumulator: `(inorder t acc)` returns the inorder list of `t` followed by `acc`. Building the list with `cons` from the right means no `append` or `reverse` is needed and each node is visited once.
  - inorder: left, node, right
  - preorder: node, left, right
  - postorder: left, right, node
- **`height`**: 0 for `()`, otherwise 1 plus the larger subtree height.
- **`leaf-count`**: 0 for `()`, 1 for a node whose two subtrees are both `()`, otherwise the sum over the subtrees.

| Function | Output |
|---|---|
| `(print-inorder tree)` | inorder list on one line |
| `(print-all-traversals tree)` | inorder, preorder, postorder on three lines |
| `(print-height-and-leaves tree)` | `(height leaf-count)` on one line |

Only allowed built-ins are used (`define`, `if`, `cond`, `and`, `null?`, `cons`, `car`, `cadr`, `caddr`, `+`, `max`, `list`, `display`, `newline`).

### How to run

The test file contains only calls (no `#lang` line), so join it to the code file first. This is what the grader does.

```powershell
Get-Content code\58_q3.rkt, tests\test_q3.rkt | Set-Content run_q3.rkt
racket run_q3.rkt
Compare-Object (racket run_q3.rkt) (Get-Content tests\test_q3_expected.txt)
```

```bash
cat code/58_q3.rkt tests/test_q3.rkt > run_q3.rkt
racket run_q3.rkt | diff - tests/test_q3_expected.txt && echo "ALL PASS"
```

No output from `Compare-Object` (or `ALL PASS`) means every line matches. Running `racket code\58_q3.rkt` alone should print nothing.

---

## 6. S2: Conditional Insert into a Nested List (`code/58_q4.rkt`)

### How it works

`insert-if-short x lst n` puts `x` at the front of every list, at every nesting level, whose **original** length is less than `n`.

- **`my-length`, `my-reverse`, `my-map`**: own helpers, because `length`, `reverse` and `map` are forbidden. `my-map` is tail-recursive (accumulate, then reverse), so lists of 10,000 elements are safe.
- **`my-list?`**: true for `'()` and pairs. `pair?` alone is false for `()`, which would wrongly treat an empty list as an atom.
- **`make-inserter x len-ok?`**: returns a function that recursively processes each element (sublists first), then checks the length of the original list with `len-ok?` and conses `x` on if it passes. The length is taken from the untouched list, so insertions never change it.
- **`insert-if-short`**: defined as `((make-inserter x (lambda (len) (< len n))) lst)`. The final file has exactly one definition of it.
- **`print-insert-result`**: reads `x`, `lst`, `n` with `read` in that order, prints the result with `display` and a newline, and prints nothing else.

### How to run

Function tests:

```powershell
Get-Content code\58_q4.rkt, tests\test_q4.rkt | Set-Content run_q4.rkt
racket run_q4.rkt
Compare-Object (racket run_q4.rkt) (Get-Content tests\test_q4_expected.txt)
```

Standard input test (the grader appends `(print-insert-result)` and pipes the input):

```powershell
Get-Content code\58_q4.rkt | Set-Content run_q4_stdin.rkt
Add-Content run_q4_stdin.rkt "(print-insert-result)"

"42 ((1 2) (3 4 5) (6) ()) 3"    | racket run_q4_stdin.rkt   # ((42 1 2) (3 4 5) (42 6) (42))
"0 (((1) 2) (3) ((4 5 6) ())) 3" | racket run_q4_stdin.rkt   # ((0 (0 1) 2) (0 3) (0 (4 5 6) (0)))
"7 () 3"                         | racket run_q4_stdin.rkt   # (7)
"7 () 0"                         | racket run_q4_stdin.rkt   # ()
```

```bash
cat code/58_q4.rkt tests/test_q4.rkt > run_q4.rkt
racket run_q4.rkt | diff - tests/test_q4_expected.txt && echo "ALL PASS"
echo "7 () 3" | racket <(cat code/58_q4.rkt; echo "(print-insert-result)")
```

Running `racket code\58_q4.rkt` alone should print nothing.

---

## 7. Rules followed

| Rule | How it is met |
|---|---|
| Prolog: no `assert`, `retract`, global variables | None used |
| Prolog: allowed libraries only (`lists`, `apply`, `yall`, `aggregate`) | Only `lists` and `aggregate` |
| Prolog: no `halt/0`, no `initialization` | None in the files; `-t halt` is given on the command line |
| Prolog: nothing printed beyond what is specified | `main` prints only the four solution lines |
| Racket files start with `#lang racket/base` | Yes |
| Racket: only listed built-ins | No `length`, `append`, `map`, `reverse`, `set!`, vectors, strings, hash tables or loops |
| Racket: files contain only definitions | No top-level calls, nothing printed on load |
| State passed through arguments | Accumulators and named `let`, no mutation |

## 8. Cleaning up before submitting

The `run_*.rkt` files are temporary. Delete them, or add this to `.gitignore`:

```
run_*.rkt
```

## 9. Process notes

- **Skill files** (`skills/prolog-dev/SKILL.md`, `skills/scheme-dev/SKILL.md`) hold the language version, coding conventions, how to run and test, a self-review checklist and known AI failure modes.
- **Prompts** (`prompts/P1.md`, `P2.md`, `S1.md`, `S2.md`) hold the prompts used for each problem, word for word.
- **Commits** are made in small steps, one unit of work each (one predicate, one function, one test file), as the decomposition rule requires.
- **Queries about submission:** Mr. Amogh Chatterjee, f20230062@hyderabad.bits-pilani.ac.in