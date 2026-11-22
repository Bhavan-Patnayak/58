---
name: prolog-dev
description: Guidelines and conventions for writing, testing, and reviewing SWI-Prolog 9.x code for CS F301 Assignment 2 logic programming tasks.
---

# Prolog Development Skill (`prolog-dev`)

## Environment & Language
- **Language & Version:** SWI-Prolog 9.x.
- **Target Files:** `23BCE123_q1.pl` and `23BCE123_q2.pl` inside `code/`, containing only definitions (no `initialization` directives).
- **Allowed Libraries Only:** `lists`, `apply`, `yall`, `aggregate`.

## Coding Conventions
- **Naming:** Use `snake_case` for predicates, functors, and atoms; use `PascalCase` for variables.
- **Comments & Declarative Reading:** Every predicate should have a concise header comment stating its arity, modes (`+`, `-`, `?`), and a short *declarative reading* (what holds when the predicate succeeds) alongside procedural/termination notes where needed.
- **Pure / Declarative Discipline:** Do **not** use `assert/1`, `retract/1`, `asserta/1`, `assertz/1`, or global variables (`b_setval/2`, `nb_setval/2`). Pass state explicitly through arguments.
- **No String-to-Term Evaluation:** Never construct a string/atom and parse or evaluate it dynamically as a term to solve arithmetic expressions.

## Running & Testing Code
- **Running `main/0`:**
  ```bash
  swipl -q -f code/23BCE123_q1.pl -g main -t halt