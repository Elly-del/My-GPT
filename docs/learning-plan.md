# Learning plan

## Path (about two months, weekends)

| Step | Folder | Material |
|---|---|---|
| 1. Python warm-up + intuition | `01_python_warmup/` | 3Blue1Brown deep learning ch. 1–2, exercises below |
| 2. micrograd | `02_micrograd/` | Karpathy, "The spelled-out intro to neural networks and backpropagation" |
| 3. makemore (parts 1–2) | `03_makemore/` | Karpathy, makemore videos: bigram, then MLP. PyTorch installed here |
| 4. GPT | `04_gpt/` | Karpathy, "Let's build GPT: from scratch, in code, spelled out" |
| 5. Optional | — | Compare with the nanoGPT repo; nanochat as a sequel |

Side material for maths gaps: 3Blue1Brown "Essence of linear algebra",
episodes 1–4 (matrix multiplication as many dot products).

## Current status

Session 1 not yet done. Update this line after each session.

## Session 1 (about 3 hours)

Videos:
- Ch. 1, But what is a neural network? https://www.youtube.com/watch?v=aircAruvnKk
- Ch. 2, Gradient descent: https://www.youtube.com/watch?v=IHZwWFHWa-w
- Hook: interactive digit demo at https://www.3blue1brown.com/lessons/neural-networks

Blocks:
1. Videos (40 min). Then ask, without correcting yet: what does learning
   change inside the network? Why do we need derivatives?
2. `vectors.py` (45 min): `Vector2D` class with `norm`, `__repr__`,
   `__add__`, `__mul__` by a scalar. Puzzle: why does `2 * u` fail while
   `u * 2` works? (Answer to discover: `__rmul__`.)
3. `derivative.py` (40 min): numerical derivative of f(x) = 3x² − 4x + 5.
   Compare with f'(3) = 14 by hand. Shrink h to 1e-15 and explain why it
   breaks (floating point). Plot f and its tangent at x = 3.
4. `value.py` (40 min): `Value` class storing data, parents and op.
   Build d = a*b + c with a=2, b=−3, c=10 (d = 4). Compute dd/da, dd/db,
   dd/dc numerically (−3, 2, 1). Key question: why is dd/da equal to b?
   Don't name backpropagation yet. Stretch: recursive graph printer.
5. Wrap-up (10 min): revisit her answers from block 1.

Homework: add `__sub__`, `__pow__`, `tanh()` to `Value`, and make
`Value(2) + 3` work by wrapping plain numbers.

If block 2 takes the whole time, stop there. Classes must be solid before
micrograd.
