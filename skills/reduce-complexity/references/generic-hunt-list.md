# Generic Hunt List (language-agnostic)

Use this when the target codebase is not TypeScript/JavaScript. Map each
concept to the idioms of the language at hand.

1. **Nested conditionals doing too much**
   - TS: ternary chains, nested `? :`
   - Python: nested `if else` expressions, conditional comprehensions
   - Rust: nested `match` arms with logic, chained `if let`
   - Go: nested `if err != nil` blocks with extra logic
   - Rule: if a conditional has side effects, function calls, or object
     construction in its branches, flatten it to named intermediates or
     early returns.

2. **Dense expressions**
   - TS: chained optional chaining `?.`, nullish coalescing `??`, inline casts `as`
   - Python: chained `get()` with defaults, nested list/dict comprehensions
   - Rust: chained `map/unwrap_or`, nested `?` with extra logic
   - Go: chained type assertions, nested `if ok` with multiple operations
   - Rule: if an expression combines 3+ operations, split it. Name the
     intermediate so the reader knows what the value *is*.

3. **Clever one-liners**
   - TS: `??=` map-building, `.filter(Boolean)`, expression-bodied arrows
   - Python: one-liner `lambda` with side effects, nested `any/all`
   - Rust: iterator chains that hide control flow, `collect()` followed by
     immediate re-iteration
   - Go: `if err := fn(); err != nil` when `fn()` does multiple things
   - Rule: a plain loop, block, or early return reads faster than a clever
     construct that saves one line.

4. **Comments that lie or state the obvious**
   - Rule: delete comments that repeat the code. Add comments that explain
     *why*, not *what*. If the code needs a comment to explain *what*,
     rewrite the code.

5. **Naming that forces a lookup**
   - TS: `result`, `data`, `items`, bare `map`
   - Python: `res`, `data`, `lst`, `dic`
   - Rust: `val`, `tmp`, `it`
   - Go: `tmp`, `res`, `x`
   - Rule: the name should reveal intent or role, not just type.
