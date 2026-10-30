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

Lesson 1 done on 2026-10-11 (videos, `vectors.py`). Next: lesson 2
(`derivative.py`, `value.py`). Update this line after each session.

## Session 1 (about 3 hours)

Run as two lessons: blocks 1-2 are lesson 1, blocks 3-5 are lesson 2.
Tutor guides (Typst source and PDF) are in `docs/lessons/`.

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

## Session 2 (about 3 hours)

Run as two lessons on Karpathy's micrograd video. Lesson 3 covers the
video's 0:32 to 1:27 in code the learner writes herself; lesson 4 covers
1:44 to the end. Tutor guide for lesson 3 in `docs/lessons/`.

Lesson 3, `02_micrograd/engine.py` (starts from the lesson 2 `Value`):
1. Warm-up (10 min): homework check, `3 + Value(2.0)` and `tanh()`.
2. Gradients by hand (35 min): extend the lesson 2 graph with f = -2 and
   L = d * f (L = -8). Nudge each input, then get the same numbers with
   the chain rule along the graph (dL/da = 6, dL/db = -4, dL/dc = -2,
   dL/df = 4). Add a `grad` attribute, fill it by hand from L down. Name
   backpropagation only now. One uphill step: L goes to -7.286.
3. `_backward` and `backward()` (40 min): functions as values, a
   `_backward` closure stored on each result, why the order matters, a
   `backward()` with a topological order. Check on a tanh neuron
   (x1 = 2, x2 = 0, w1 = -3, w2 = 1, b = 6.8813735870195432): o = 0.7071,
   n.grad = 0.5, w1.grad = 1.0, w2.grad = 0.
4. The `a + a` bug (10 min): `=` gives a.grad = 1, `+=` gives 2.
5. Wrap-up and commit (5 min).

Homework: watch the video 0:32 to 1:39; `_backward` for `__pow__`;
`exp()`, `__truediv__`, `__neg__`; rebuild the neuron with tanh spelled
out from exp and check the gradients match.

Lesson 4: `Neuron`, `Layer` and `MLP` classes, a loss on four examples,
gradient descent by hand, then the first training loop.
