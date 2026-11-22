# P1 Report: Department Assignment Puzzle, Reloaded

## 1. Number of Solutions for Clues 1–8

The predicate `count_solutions/2` was used to count all assignments satisfying the first eight clues.

Query:

```prolog
count_solutions([1,2,3,4,5,6,7,8], N).
```

Result:

```text
N = 3
```

There are **3 valid solutions** satisfying all eight original clues.

## 2. Interpretation

The original puzzle is underconstrained because the eight clues do not uniquely determine the assignments of departments, programming languages, and project preferences to the four friends.

Three different assignments satisfy all the given conditions. Therefore, an additional clue is required to eliminate the ambiguity and obtain a unique solution.

## 3. Additional Clue (Clue 9)

The following clue was introduced:

**The friend working in the design department prefers embedded projects.**

This clue is implemented as:

```prolog
clue(9, Sol) :-
    member(p(_, design, _, embedded), Sol).
```

After including clue 9, the following query was executed:

```prolog
count_solutions([1,2,3,4,5,6,7,8,9], N).
```

Result:

```text
N = 1
```

## 4. Conclusion

The original eight clues produce three valid assignments, showing that the puzzle does not have a unique solution.

Adding the ninth clue reduces the number of valid assignments to exactly one. Thus, the additional clue successfully removes the ambiguity and makes the puzzle uniquely solvable.