---
name: scheme-dev
description: Strict built-in whitelist, conventions, run/test commands, self-review checklist and known failure modes for writing Racket 8.x (#lang racket/base) code for CS F301 Assignment 2 (S1 trees, S2 nested insert).
---

# Scheme Development Skill (`scheme-dev`)

## Environment and language
- **Language and version:** Racket 8.x, files start with `#lang racket/base` (never `#lang racket`).
- **Target files:** `code/58_q3.rkt` (S1) and `code/58_q4.rkt` (S2). They contain only definitions: no top-level calls, nothing printed on load. The grader appends its own calls.

## Strict built-in whitelist
Only these may be used:
- **Binding and control:** `define`, `lambda`, `let`, `let*`, `letrec`, named `let`, `if`, `cond` (with `else`), `and`, `or`, `not`, `begin`, `quote` (`'`)
- **Pairs and lists:** `cons`, `car`, `cdr`, `list`, and every composition of `car`/`cdr` up to four levels (`cadr`, `cddr`, `caddr`, `cdddr`, `cadddr`, `cddddr`, and so on)
- **Predicates and lookup:** `null?`, `pair?`, `eq?`, `assq`, `assoc`
- **Arithmetic and comparison:** `+`, `-`, `*`, `<`, `>`, `<=`, `>=`, `=`, `max`
- **I/O:** `display`, `newline`; `read` only in S2

### Forbidden
- **Not in the list, so do not use:** `/`, `abs`, `zero?`, `add1`, `sub1`, `equal?`, `list?`, `number?`, `symbol?`, `void`, `let-values`, `when`, `unless`, `case`, `printf`, `require`.
- **No mutation or other data structures:** no `set!` or relatives, vectors, hash tables, strings.
- **No loops:** no `do`, `for` or relatives.
- **No library list functions:** `length`, `append`, `reverse`, `map`, `filter`, `member`, `memq`, `list-ref`, `list-tail`. Write helpers (`my-length`, `my-reverse`, `my-map`) from allowed built-ins.

## Coding conventions
- **Naming:** `kebab-case` for functions and variables; predicates end in `?`.
- **Comments:** every function has its signature, purpose and a *recursive reading* (base case, recursive step, accumulator invariant if tail-recursive).
- **State:** pass all state through arguments. Prefer tail recursion with accumulators, since hidden tests use nesting depth 100 and lists of 10,000 elements.
- **Empty list:** `pair?` is false for `'()`, so test `null?` separately when `()` must count as a list.

## Running and testing
`racket code\58_q3.rkt` alone only loads the file. It should print nothing, which is the load check. To test, join the code file with a test file that holds only calls (no `#lang` line), as the grader does:

```
Get-Content code\58_q3.rkt, tests\test_q3.rkt | Set-Content run_q3.rkt
racket run_q3.rkt
Compare-Object (racket run_q3.rkt) (Get-Content tests\test_q3_expected.txt)
```
```
cat code/58_q3.rkt tests/test_q3.rkt > run_q3.rkt
racket run_q3.rkt | diff - tests/test_q3_expected.txt && echo "ALL PASS"
```

For S2 input (`print-insert-result`), append the call and pipe the input:
```
Get-Content code\58_q4.rkt | Set-Content run_q4_stdin.rkt
Add-Content run_q4_stdin.rkt "(print-insert-result)"
"42 ((1 2) (3 4 5) (6) ()) 3" | racket run_q4_stdin.rkt
```
Delete the temporary `run_*.rkt` files before committing.

## Self-review checklist (apply before answering)
1. First line is `#lang racket/base`, and the file prints nothing when loaded.
2. Every identifier used is on the whitelist. Scan for `length`, `append`, `reverse`, `map`, `filter`, `list?`, `equal?`, `/`, `abs`, `zero?`, `when`, `unless`, `require`.
3. No `set!`, vectors, strings, hash tables, `do` or `for`.
4. Every function has a signature comment and a recursive reading.
5. All state passes through arguments; recursion is tail-recursive where natural.
6. Every example in the PDF passes as a test, including the empty tree and `() 0` cases.
7. Output format is exact: one line per `display` list, each call ends with a newline, nothing else printed (no prompts).
8. Stress tests pass: depth 100 and 10,000 elements.
9. S2 has a single definition of `insert-if-short`, built on `make-inserter`.
10. Helper definitions do not shadow built-ins in a way that breaks other code.

## Known AI failure modes for Scheme
- **Reaching for forbidden built-ins** (`length`, `append`, `map`, `reverse`, `filter`, `member`) out of habit, or for ones that are simply not on the list (`list?`, `equal?`, `zero?`, `abs`, `/`, `add1`).
- **`#lang racket` instead of `#lang racket/base`**, which hides forbidden-function use because they all load.
- **Treating `()` as an atom** by using `pair?` alone, so empty lists never get the inserted element (S2).
- **Measuring length after insertion** instead of on the original list (S2).
- **Non-tail recursion** that is slow or memory-heavy on 10,000 elements; or a `my-map` that conses in the wrong order and forgets to reverse.
- **Top-level calls or prints** left in the file, which break the grader.
- **Wrong leaf definition** (S1): counting `()` as a leaf, or a node with one empty child as a leaf.
- **Wrong height base case:** height of `()` must be 0, so a single node is 1.
- **Wrong output form:** printing with `write` or `print`, printing the list without a trailing newline, or printing strings or extra text.
- **Mixing up traversal order** (preorder versus postorder), or using `append` to build the lists.
- **Two definitions of `insert-if-short`** left in the final file (S2).
- **Claiming it was tested without running it.** Always run the commands above and report actual output.