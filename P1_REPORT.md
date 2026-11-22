# P1 Report: Department Assignment Puzzle, Reloaded

**Course:** CS F301 Principles of Programming Languages, Assignment 2
**Group:** 42
**File:** `code/58_q1.pl`
**Language:** SWI-Prolog 9.x

---

## 1. Summary

| Question | Answer |
|---|---|
| Solutions satisfying clues 1 to 8 (P1.b) | **N = 3** |
| Solutions satisfying clues 1 to 9 (P1.c) | **N = 1** |
| Verdict on the original puzzle | Under-constrained (ambiguous) |
| Clue added | Clue 9: the friend in the design department prefers embedded projects |

---

## 2. Approach

The program follows a generate-and-test design.

1. **Generate.** `solution/1` builds a list of four terms `p(Name, Dept, Lang, Project)` for Alex, Ben, Carla and Dana. Each attribute (department, language, project) is a `permutation/2` of its four values, so every friend gets a different value for each attribute. This gives 24 x 24 x 24 = 13,824 candidate assignments.
2. **Test.** Each clue is its own clause `clue(N, Solution)` that succeeds exactly when clue N holds in a fully filled-in solution. Clues look friends up with `member/2`, either by name (`'Ben'`) or by attribute value (`testing`, `java`), as the assignment requires.
3. **Combine.** `valid_for_clues/2` checks that every clue number in a list holds. Because clues are selected by number, the same code supports the solver (`main`), the counter (`count_solutions/2`) and the repair check.

No `assert`, `retract` or global variables are used. Only `lists` and `aggregate` are needed. The program is not hard-coded: the answer comes from the clues.

---

## 3. P1.a: Solving the puzzle

`main/0` takes the first candidate that satisfies clues 1 to 8 and prints it in the required format:

```text
<Name> = [<Dept>, <Lang>, <Project>]
```

The cut in `main` stops it after the first solution. Since clues 1 to 8 have three solutions (section 4), `main` prints one of those three.

---

## 4. P1.b: Counting solutions (N for clues 1 to 8)

`count_solutions(Active, N)` uses `aggregate_all(count, ...)` over all candidates that satisfy exactly the clues in `Active`.

```prolog
?- count_solutions([1,2,3,4,5,6,7,8], N).
N = 3.
```

### The three solutions

| | Alex | Ben | Carla | Dana |
|---|---|---|---|---|
| **A** | design, java, embedded | development, javascript, web | testing, python, AI | research, c++, data |
| **B** | testing, python, embedded | development, javascript, web | design, java, AI | research, c++, data |
| **C** | design, java, AI | development, javascript, web | research, c++, data | testing, python, embedded |

(Each cell is `department, language, project`.)

### What N = 3 tells us

- **The puzzle is under-constrained.** A well-posed logic puzzle has exactly one solution, and this one has three. It cannot be solved by deduction alone.
- **Some facts are forced and some are not.** Ben is always `development, javascript, web`. Who works in design, testing and research, and who gets AI and embedded, is not determined.
- **A clue that removes the ambiguity is missing.** Section 5 adds one.

---

## 5. P1.c: Repair with clue 9

```prolog
% CLUE 9: The friend working in the design department prefers embedded projects.
clue(9, Sol) :-
    member(p(_, design, _, embedded), Sol).
```

The clue meets the requirements:

- It **names no friend**. It refers to friends only through attribute values, as clue 5 does.
- It is **true in the solution we keep** (A): the design friend, Alex, prefers embedded.
- It is **false in every other solution** of clues 1 to 8: in B (Carla) and C (Alex) the design friend prefers AI.

| Solution | Design friend | Their project | Clue 9 holds? |
|---|---|---|---|
| A | Alex | embedded | Yes |
| B | Carla | AI | No |
| C | Alex | AI | No |

```prolog
?- count_solutions([1,2,3,4,5,6,7,8,9], N).
N = 1.
```

The unique solution is A:

```text
Alex  = [design, java, embedded]
Ben   = [development, javascript, web]
Carla = [testing, python, AI]
Dana  = [research, c++, data]
```

---

## 6. How to run

From the repository root:

```powershell
# P1.a: print one solution of clues 1 to 8
swipl -q -f code\58_q1.pl -g main -t halt

# P1.b: count solutions of clues 1 to 8 (expect 3)
swipl -q -f code\58_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8],N),write(N),nl" -t halt

# P1.c: count solutions of clues 1 to 9 (expect 1)
swipl -q -f code\58_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8,9],N),write(N),nl" -t halt
```

---

## 7. Compliance checklist

| Requirement | Status |
|---|---|
| Each clue is its own `clue(N, Solution)` clause | Yes |
| Answer derived from the clues, not hard-coded | Yes |
| `count_solutions/2` uses `findall/3` or `aggregate_all/3` | Yes (`aggregate_all/3`) |
| Clue 9 comment `% CLUE 9:` directly above the clause | Yes |
| Clue 9 mentions no friend by name | Yes |
| No `assert`, `retract` or global variables | Yes |
| Only allowed libraries (`lists`, `aggregate`) | Yes |
| No `halt/0` call and no `initialization` directive | Yes |
| Nothing printed except what is specified | Yes |

---

## 8. Conclusion

The eight original clues leave the puzzle ambiguous, with N = 3 valid assignments. Clue 9 is true in exactly one of them, bringing the count to N = 1 and making the puzzle uniquely solvable. Solution A is the answer.