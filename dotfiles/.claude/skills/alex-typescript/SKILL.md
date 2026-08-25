---
name: alex-typescript
description: Good practices to follow whenever a .ts or .tsx file is being written or edited. Must always apply.
---

# TypeScript engineering practices

Apply these whenever writing or editing `.ts`/`.tsx` files. Not a style guide to lecture from, just defaults to reach for.

## Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:

- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## Check your surroundings

- Read the file, its tests, and sibling implementations before editing.
- Check for a pattern doc, README, or CLAUDE.md nearby.
- Grep for an existing helper/type/component before writing a new one; extend a near-fit instead of forking it.
- Only add a new abstraction when nothing covers the case, and say why.

## Type coverage rules

- Types must fail fast and never lie. No `any` outside tests or a genuinely unused type param.
- Never `as unknown as`. Don't `as` without a runtime check backing it.
- Interfaces make inputs explicit at a glance. Narrow primitives (`string` → union/enum/branded type) when the domain is narrower.
- Favor Effect-TS discipline: failure as data, pure functions, side effects at the edges, small typed pieces.

## Module design and placement

Interface design:

- Aim for deep modules: small interface, real behavior behind it. If deleting the module would just push its complexity onto every caller, it was earning its keep - keep that shape.
- The interface is everything a caller must know (signature, invariants, errors, config), not just the type signature. Keep it small; hide the rest.
- Don't add a seam (extra interface/adapter) for a single implementation. One implementation is a hypothetical seam; two is a real one.
- Accept dependencies as params, return results instead of mutating - it's what makes the interface testable.

File/module placement (LIFT, from the Angular style guide):

- **Locate** - name and place a file so a reader finds it fast without an index.
- **Identify** - the filename and top-level exports say what's inside at a glance.
- **Flat** - keep folder nesting shallow; go deeper only once a folder holds too many files to scan.
- **Try to be DRY** - reuse existing modules per "Check your surroundings" above, but not at the cost of a deep, tangled folder tree.

## Pick the right data structure

- `map`/`filter`/`reduce`/`find`/`flatMap` over a loop that pushes into a result array.
- `Map` for non-string keys or `.has`/`.delete`/`.size`; `Set` for uniqueness/membership; `WeakMap`/`WeakSet` for identity-keyed metadata that shouldn't block GC.
