---

### 2. Updated `skills/scheme-dev/SKILL.md`

```markdown
---
name: scheme-dev
description: Guidelines, restricted primitive whitelist, and verification rules for writing Racket 8.x (#lang racket/base) code for CS F301 Assignment 2 Scheme problems.
---

# Scheme Development Skill (`scheme-dev`)

## Environment & Language
- **Language & Version:** Racket 8.x starting with `#lang racket/base` only.
- **Target Files:** `code/23BCE123_q3.rkt` (S1) and `code/23BCE123_q4.rkt` (S2), containing only definitions (no top-level function calls or prints when loaded; the grader adds calls).

## Strict Built-In Whitelist
Only the following built-ins may be used:
- **Binding & Control:** `define`, `lambda`, `let`, `let*`, `letrec`, named `let`, `if`, `cond` (with `else`), `and`, `or`, `not`, `begin`, `quote` (`'`)
- **Pairs & Lists:** `cons`, `car`, `cdr`, `list`, and compositions of `car`/`cdr` up to 4 levels (`cadr`, `cddr`, `caddr`, `cdddr`, `cadddr`, `cddddr`, etc.)
- **Predicates & Association:** `null?`, `pair?`, `eq?`, `assq`, `assoc`
- **Arithmetic & Comparison:** `+`, `-`, `*`, `/`, `<`, `>`, `<=`, `>=`, `=`, `max`
- **I/O:** `display`, `newline` (and `read` in `code/23BCE123_q4.rkt` / S2 only)

### Explicitly Forbidden Constructs
- **No mutation or non-list data structures:** No `set!`, vectors, hash tables, or strings.
- **No imperative loops:** No `do` or `for` forms.
- **No unlisted list utilities:** `length`, `append`, `reverse`, `map`, `filter`, `member`, `memq`, `list-ref`, and `list-tail` are forbidden. Implement custom tail-recursive helpers (e.g., `my-length`, `my-reverse`, `my-map`) using only allowed built-ins.

## Coding Conventions
- **Naming:** Use `kebab-case` for functions and variables, ending predicates with `?` (e.g., `len-ok?`).
- **Comments & Recursive Reading:** Document every function with its signature, purpose, and a *recursive reading* (base case(s), recursive step, and accumulator invariants if tail-recursive).
- **State Passing & Tail Recursion:** Pass all state through function arguments. Prefer tail recursion with accumulators where natural—especially for deep nesting (depth 100+) and long lists (10,000+ elements) to avoid stack overflow.

## Running & Testing Code
- **Run S1:**
  ```bash
  racket code/23BCE123_q3.rkt