// Tutor guide for lesson 2. Build from the repo root:
// typst compile docs/lessons/lesson-02-derivatives.typ
#import "template.typ": *

#show: guide.with(
  number: 2,
  title: "Derivatives, and numbers that remember",
  subtitle: "Slopes measured by nudging, why h cannot shrink forever, partial derivatives, and a Value class that records how it was computed.",
  meta: (
    ("Duration", [About 1 h 40 min, plus homework.]),
    ("Files", [`01_python_warmup/derivative.py` and `01_python_warmup/value.py`, both empty at the start.]),
    ("Before", [Lesson 1 done. `import matplotlib` works in the `.venv`, otherwise run `uv pip install -r requirements.txt`. Have the learner's written answers from lesson 1, block 1, at hand.]),
    ("Goals", [The learner estimates a derivative numerically, explains why `h` cannot go to zero on a computer, reads a partial derivative as "nudge one input, freeze the others", explains why the derivative of `a * b + c` with respect to `a` is `b`, and builds a class whose `+` and `*` remember their inputs.]),
    ("Run", [On 2026-11-01. A session review, a catch-up plan before lesson 3 and a reference solution follow the homework.]),
  ),
)

= How to run this session

The rules from lesson 1 still hold.

- Ask for a prediction before every run.
- Give hints in order, only after a real attempt, and keep your hands off the keyboard.
- The learner reads errors aloud before anyone edits. Every message quoted here was checked on Python 3.14.
- Green boxes are for you.

Do not say "backpropagation" yet. The learner should find the idea before lesson 3 gives it a name.

#table(
  columns: (1fr, auto, auto),
  table.header[*Block*][*Time*][*Where*],
  [Warm-up], [5 min], [],
  [1. The numerical derivative], [40 min], [`derivative.py`],
  [2. Partial derivatives and `Value`], [45 min], [`value.py`],
  [3. Wrap-up and commit], [10 min], [`README.md`, terminal],
)

= Warm-up (5 min)

#ask[Without looking at the code: why does `2 * u` fail while `u * 2` works, and what fixed it?]

#expect[
  `int.__mul__` returns `NotImplemented`, so Python tries `__rmul__` on the right object. If the answer is shaky, spend five more minutes on it. Block 2 relies on the same mechanism.
]

= Block 1: the numerical derivative

All of block 1 goes in `derivative.py`. The function is $f(x) = 3x^2 - 4x + 5$.

== Step 1: f in Python, and its derivative by hand

#task[Write `f` as a Python function. The learner computes `f(3)` by hand before running it.]

#expect[`f(3)` gives `20`.]

#watch[
  - `SyntaxError: invalid decimal literal` on `3x**2`. Python needs `3 * x**2`.
  - `x^2` runs without an error and gives a wrong number. In Python `^` is bitwise XOR, not a power, so `10 ^ -15` is `-5`. This one bites again in step 4 when writing small values of `h`.
]

#ask[On paper: what is $f'(x)$, and what is $f'(3)$?]

#expect[$f'(x) = 6x - 4$, so $f'(3) = 14$. This is terminale material and should take a minute.]

== Step 2: measuring the slope without the formula

#ask[Using only `f`, with no formula for $f'$, how could you measure the slope at $x = 3$?]

#hints[
  + "A slope is rise over run. Pick two points very close together on the curve."
  + "Nudge `x` by a small `h`. How much did `f` move? Divide by `h`."
]

#expect[`(f(3 + h) - f(3)) / h`. With `h = 0.001` it prints `14.00300000000243`.]

#ask[Why 14.003 and not 14? Expand $f(3 + h)$ by hand.]

#expect[
  $f(3 + h) = 20 + 14h + 3h^2$, so the ratio is exactly $14 + 3h$ and the error is $3h$. Have the learner predict the result for `h = 0.01` and `h = 0.1` before running. The code prints `14.029999999999632` and `14.300000000000068`, which are 14.03 and 14.3 plus float noise.
]

== Step 3: other points, and which way is downhill

#ask[Predict the slope at $x = -3$. Then find the $x$ where the slope is zero.]

#expect[
  $f'(-3) = -22$, and the code gives `-21.997` with `h = 0.001`. The slope is zero at $x = 2/3$, the bottom of the parabola, where the code gives `0.003`.
]

#ask[You stand at $x = 3$ and want $f$ smaller. Do you step left or right? What told you?]

#expect[
  Left, because the slope is positive. The sign of the derivative points uphill, so you step the other way. This is gradient descent from chapter 2, in one dimension.
]

== Step 4: shrinking h until it breaks

#task[
  A loop over `h` from `0.1` down to `1e-16`, printing the estimate each time. Before running it, the learner predicts whether the estimate keeps getting closer to 14.
]

#expect[
  #table(
    columns: (auto, auto),
    align: (right, left),
    table.header[*`h`*][*Estimate of $f'(3)$*],
    [`0.1`], [`14.300000000000068`],
    [`0.01`], [`14.029999999999632`],
    [`0.001`], [`14.00300000000243`],
    [`1e-06`], [`14.000003002223593`],
    [`1e-08`], [`14.00000009255109`],
    [`1e-10`], [`14.000001158365194`],
    [`1e-12`], [`14.001244608152774`],
    [`1e-14`], [`14.210854715202004`],
    [`1e-15`], [`10.658141036401503`],
    [`1e-16`], [`0.0`],
  )
]

#ask[The maths says a smaller `h` is always better. Why does the computer disagree?]

#hints[
  + "Run `3 + 1e-16 == 3`." It prints `True`.
  + "A float keeps about 16 significant digits. Where does the last 1 of `3.0000000000000001` go?"
]

#expect[
  Near 3, two neighboring floats are about `4.4e-16` apart, so `3 + 1e-16` rounds back to 3 and the numerator is 0. Around `h = 1e-14`, `f(3 + h)` and `f(3)` agree on almost every digit, and their difference keeps only one or two correct ones. The estimate is best near `h = 1e-8`, where the $3h$ error and the rounding error are about the same size.
]

== Step 5: plot f and its tangent at x = 3

#ask[What is the equation of the tangent to $f$ at $x = 3$?]

#expect[$y = f(3) + f'(3)(x - 3)$, so $y = 20 + 14(x - 3)$.]

The learner writes a function `tangent(x)` from that equation. The plotting code is not what this lesson teaches, so hand it over:

```python
# %% Plot f and its tangent at x = 3
import matplotlib.pyplot as plt

xs = [i / 10 for i in range(-20, 61)]  # x from -2 to 6, step 0.1
plt.plot(xs, [f(x) for x in xs], label="f")
plt.plot(xs, [tangent(x) for x in xs], label="tangent at x = 3")
plt.scatter([3], [f(3)], color="red", zorder=3)  # the point (3, 20)
plt.legend()
plt.grid(True)
plt.show()
```

#expect[
  The line touches the parabola at (3, 20) and stays below it everywhere else. At $x = 4$ the gap is $37 - 34 = 3$, which is the $3h^2$ term from step 2 with $h = 1$.
]

= Block 2: partial derivatives and the `Value` class

All of block 2 goes in `value.py`.

== Step 1: three inputs

#task[
  With plain floats, `a, b, c = 2.0, -3.0, 10.0` and `d = a * b + c`. The learner predicts `d` first.
]

#expect[`4.0`]

#ask[
  If you nudge `a` up a tiny bit and leave `b` and `c` alone, does `d` go up or down? By how much, compared to the nudge? Then the same questions for `b`, and for `c`.
]

#hints[
  + "It is the trick from `derivative.py`, but only one input moves."
  + "Compute `d` once, then again with `a + h` in place of `a`."
]

#expect[
  With `h = 0.0001`, the three slopes print as:
  - `-3.000000000010772` for `a`
  - `2.0000000000042206` for `b`
  - `0.9999999999976694` for `c`
]

Now give the idea its name. A derivative with respect to one input, with the others frozen, is a partial derivative. It is written $partial d \/ partial a$ and read "partial d over partial a".

#ask[Why is $partial d \/ partial a$ equal to $b$?]

#hints[
  + "Freeze $b = -3$ and $c = 10$. Write $d$ as a function of $a$ alone."
  + "What is the slope of $d = -3a + 10$?"
]

#expect[
  With $b$ and $c$ frozen, $d$ is a straight line in $a$ whose slope is $b$. In the same way, $partial d \/ partial b = a = 2$ and $partial d \/ partial c = 1$. To check the idea transfers, ask for $partial d \/ partial a$ when $b = 5$, without code. The answer is 5.
]

== Step 2: why Python should remember

#ask[
  How many times did you compute `d` to get the three slopes? How many would a network with 13,002 weights need for one learning step?
]

#expect[
  Four, one baseline and one per input. The network would need 13,003 full runs for a single nudge of its weights. If Python remembered how `d` was built, the derivatives could come from that record instead. Do not explain how. That is lesson 3.
]

== Step 3: the `Value` class

#task[
  Write a class `Value` that stores a number, the `Value` objects it was made from, and the operation that made it. Inputs have no parents and an empty operation. It needs `__init__`, `__repr__`, `__add__` and `__mul__`. The attribute names in the checks below match micrograd, which makes the lesson 3 video easier to follow.
]

```python
# %% Checks
a = Value(2.0)
b = Value(-3.0)
c = Value(10.0)
e = a * b
d = e + c
print(d)        # Value(data=4.0)
print(d._op)    # +
print(d._prev)  # the two parents, Value(data=-6.0) and Value(data=10.0)
print(a._prev)  # nothing, because a is an input
```

#hints[
  + "Your `Vector2D.__add__` returned a new vector. What should `Value.__add__` return, and what extra information should it pass along?"
  + "`Value(2.0)` has no parents. How do you give a parameter a default value in Python?"
]

#watch[
  - `d._prev` shows plain numbers such as `-6.0` and `10.0`. The method stored `other.data` instead of `other`. Ask: "Starting from `d`, can you get back to `a`?" With numbers, the trail stops after one step.
  - `print(d)` shows `<__main__.Value object at ...>`. `__repr__` is missing, and lesson 1 covered it.
]

#ask[Back to the wrap-up question of lesson 1. When Python runs `a * b + c` on `Value` objects, what gets built?]

#expect[
  `__mul__` builds `e` with parents `a` and `b`, then `__add__` builds `d` with parents `e` and `c`. Writing an ordinary formula builds a graph of the computation, with no extra work from the learner.
]

== Step 4, stretch: print the graph

#task[
  Add a `label` to `Value`, as micrograd does, so that `Value(2.0, label="a")` works and `e.label = "e"` can be set after `e = a * b`. Then write a function that prints how `d` was built, one line per `Value`, indented by depth. The order of siblings may differ:
]

```text
d = 4.0 (+)
  e = -6.0 (*)
    a = 2.0
    b = -3.0
  c = 10.0
```

#hints[
  + "What should the printer do with a `Value` that has no parents?"
  + "For `d`, it prints one line. What job is left for each parent? Is it the same job?"
  + "A function may call itself. Pass `depth + 1` down."
]

= Block 3: wrap-up and commit

Bring out the answers from lesson 1, block 1, and ask the same two questions again.

#ask[
  + What does learning change inside the network?
  + Why do we need derivatives?
]

#expect[
  The answers should now draw on this lesson. In `d = a * b + c`, think of `a`, `b` and `c` as weights and `d` as the cost. $partial d \/ partial a = -3$ says that raising `a` lowers `d` three times as fast, so learning would raise `a`. A network does the same for each of its 13,002 weights. Compare with the first answers out loud, and let the learner say what changed.
]

```bash
git add 01_python_warmup/derivative.py 01_python_warmup/value.py
git commit -m "derivative and value: numerical slopes, float limits, partial derivatives"
git push
```

Then a few sentences in the `README.md` journal, committed too.

= Homework

All in `value.py`, in this order. Each task makes the next one easier.

+ Make `Value(2.0) + 3` and `Value(2.0) * 3` work by wrapping plain numbers in a `Value`. Hint if needed: #link("https://docs.python.org/3/library/functions.html#isinstance")[`isinstance`].
+ Make `3 + Value(2.0)` and `3 * Value(2.0)` work. This is the `2 * u` puzzle again, and the learner should recognize it without help.
+ `__sub__`, so that `Value(5.0) - Value(3.0)` gives `Value(data=2.0)`. It can reuse `+` and `*` with `-1`, which is why tasks 1 and 2 come first.
+ `__pow__` with a plain number as exponent, so that `Value(3.0) ** 2` gives `Value(data=9.0)`. Ask whether the exponent belongs in the parents. It does not, because it is a plain number and not a `Value`.
+ `tanh()`, using $tanh(x) = (e^(2x) - 1) \/ (e^(2x) + 1)$ and `math.exp`. `Value(0.0).tanh()` gives `0.0`, and `Value(0.8813735870195432).tanh()` gives `0.7071067811865476`. Before comparing a few values with `math.tanh`, the learner predicts `tanh` at 3 and at -3. The answers are about 0.995 and -0.995.

Next: lesson 3 starts Karpathy's #link("https://www.youtube.com/watch?v=VMj-3S1tku0")[micrograd video]. Its first half hour repeats this lesson almost step by step.

#pagebreak()

= Session review, 2026-11-01

Based on the two commits of that day, `derivative.py` and `value.py`. What was said aloud leaves no trace in the files, so "not in the file" means "check whether it happened", not "missed".

#table(
  columns: (auto, 1fr, auto),
  table.header[*Goal*][*In the files*][*Status*],
  [Numerical derivative], [`pente(x, h)`. `pente(-3.0, 0.000001)` prints `-21.999997002808414`, against $f'(-3) = -22$.], [Done],
  [Why `h` cannot go to zero], [No loop over `h`, no `3 + 1e-16 == 3`.], [Not in the file],
  [Tangent and plot], [`tangente` with `20` and `14` typed in. The plot is right.], [Done],
  [Partial derivatives], [`g(a, b, c)` and `pente_a`, which prints `-3.000000000064062`. Nothing for `b` or `c`.], [Half],
  [Why $partial d \/ partial a = b$], [Aloud only, if at all.], [Ask again],
  [A `Value` that remembers its inputs], [The class exists, but its parents are plain numbers, not `Value` objects.], [Blocker],
  [Stretch: graph printer], [Absent. It cannot work until the parents are objects.], [Skip],
  [Homework], [Absent. `Value(2.0) + 3` raises an error.], [Partly needed],
)

== What is solid

- `f`, `pente`, `tangente` and the plot are short and correct. The code of block 1 needs no rework; only step 4 is missing.
- Default parameters were tried on a toy first, `mult(x, y=2)`, then used in `Value.__init__`. That is the right reflex for any new Python feature. Say so, so it sticks.
- The idea of a partial derivative, "move one input, freeze the others", is in the code: `pente_a` nudges `a` and passes `b` and `c` unchanged.

== What the code shows

These are in order of importance. Only the first one blocks lesson 3.

*1. The parents are numbers.* In `__add__` and `__mul__`, `prt1 = self.vlr` keeps `-6.0`, not the `Value` that holds it. It is exactly the first case of the step 3 "Watch for" box. From `d`, the trail stops after one step:

```text
>>> d.prt1
-6.0
>>> d.prt1.prt1
AttributeError: 'float' object has no attribute 'prt1'
```

Lesson 3 walks this trail from the output down to every input, so there is nothing to walk yet.

#ask[Starting from `d`, reach `a` in code. Read the error aloud.]

#hints[
  + "What type is `d.prt1`? Print `type(d.prt1)`."
  + "In `__add__`, which of `self` and `self.vlr` still knows its own parents?"
]

#expect[
  Storing `self` and `other` instead of their numbers. Then `d.prt1.prt1 is a` prints `True`: the `Value` objects are linked, and the graph exists.
]

*2. `__repr__` glues everything together.* `print(d)` shows `4.0-6.0+10.0` and `print(a)` shows `2NoneNoneNone`. The first one reads as a sum worth 8, while `d` is 4.

#ask[Read `4.0-6.0+10.0` aloud to someone who has not seen the code. What number do they hear?]

#expect[
  A `repr` shows the object's own value: `Value(data=4.0)`. The parents are for the printer of step 4, or for `d._prev`. Fix finding 1 first and this one gets worse: `str(self.prt1)` then calls `__repr__` on the parent, and `print(d)` shows `4.0-6.02NoneNoneNone*-3.0NoneNoneNone+10.0NoneNoneNone`. A good moment to ask what `repr` is for.
]

*3. The comments do not match the output.* The check cell keeps the guide's comments, such as `# Value(data=4.0)`, while the file prints `4.0-6.0+10.0`. A comment next to a `print` is a prediction, and the run should confirm it. Here the mismatch was the first visible sign of findings 1 and 2. Make "run, then compare with the comment" a habit before lesson 3, where every check cell works this way.

*4. The names.* `vlr`, `prt1`, `prt2` and `op` instead of `data`, `_prev` and `_op`. Lesson 3's checks, its printer and the micrograd video all use micrograd's names. One collection of parents also beats two fixed slots: `tanh` has a single parent, and `backward()` in lesson 3 loops over the parents of each node. Renaming is mechanical, so give the names directly.

*5. Plain numbers.* `Value(2.0) + 3` raises `AttributeError: 'int' object has no attribute 'vlr'`. That is homework item 1, and lesson 3 needs it in block 1, where `a + h` nudges a `Value` by a float.

*Minor.*
- `tangente` has `20` and `14` typed in. Fine for the step. To link it back to the formula, ask: "Which numbers change for the tangent at $x = 1$? Can `f` and `pente` give them?"
- `value.py` has no `# %%` cells, and `derivative.py` has one, before the plot. Without cells, every run replays the whole file, the plot window included.
- The `README.md` journal is still empty for lessons 1 and 2.

== Catch-up before lesson 3 (about 50 min)

A short session of its own, or lesson 3 runs over two sittings. In this order; each step ends on a check the learner runs.

+ *The trail* (10 min). Finding 1. Check: `d.prt1.prt1 is a` prints `True`.
+ *The names* (5 min). `data`, `_prev` for all parents together (a tuple or a set, empty for an input), `_op`, and `label=""`. `__repr__` returns `Value(data=4.0)`. Check: the step 3 check cell, unchanged, prints what its comments say.
+ *Homework items 1, 2 and 5* (20 min). Wrapping plain numbers, `3 + Value(2.0)`, `tanh()`. Lesson 3 needs the first in block 1 and `tanh` in block 2. Items 3 and 4 can wait for the lesson 3 homework, which builds on `__pow__`.
+ *Shrinking `h`* (10 min). Block 1, step 4, unless it was covered aloud. It is the only exercise on the limits of floats in the whole path.
+ *Partial derivatives, aloud* (5 min). $partial d \/ partial b$ and $partial d \/ partial c$ with `pente_a` copied, then "why is $partial d \/ partial a$ equal to $b$?" from block 2, step 1.

#ask[At $x = -3$ with `h = 1e-6`, `pente` was off by about `0.000003`. At $x = 3$ the error was $3h$ too. Why the same error at both points?]

#expect[
  $f(x + h) - f(x) = (6x - 4)h + 3h^2$, so the ratio is $f'(x) + 3h$ at every $x$. The error comes only from the $3x^2$ term, whose curvature is the same everywhere. A good check that step 2 of block 1 was understood, not memorized.
]

#pagebreak()

= Appendix: a reference solution

Show this only after the catch-up, next to the learner's files, and go through the differences together. It covers the lesson, the stretch and the homework. Names follow this guide: `slope` and `tangent` are the learner's `pente` and `tangente`. Every printed value in the comments was checked on Python 3.14.

== `derivative.py`

```python
# %% f, and its derivative by hand: f'(x) = 6x - 4, so f'(3) = 14
def f(x):
    """The parabola of the lesson."""
    return 3 * x**2 - 4 * x + 5


print(f(3))  # 20


# %% The slope, measured by nudging x
def slope(x, h):
    """Rise over run between x and x + h."""
    return (f(x + h) - f(x)) / h


print(slope(3, 0.001))  # 14.00300000000243, the exact ratio is 14 + 3h
print(slope(3, 0.01))  # 14.029999999999632
print(slope(3, 0.1))  # 14.300000000000068
print(slope(-3, 0.001))  # -21.996999999998934, exact -22
print(slope(2 / 3, 0.001))  # 0.0029999999995311555, bottom of the parabola
```

```python
# %% Shrinking h until it breaks: best near 1e-8, 0.0 at 1e-16
for h in [0.1, 0.01, 0.001, 1e-6, 1e-8, 1e-10, 1e-12, 1e-14, 1e-15, 1e-16]:
    print(h, slope(3, h))

print(3 + 1e-16 == 3)  # True: 3 + 1e-16 rounds back to 3


# %% Tangent at x = 3: y = f(3) + f'(3)(x - 3)
def tangent(x):
    """The line that touches f at x = 3."""
    return f(3) + 14 * (x - 3)


print(f(4) - tangent(4))  # 3, the 3h^2 term with h = 1
```

Then the plotting cell from block 1, step 5, unchanged.

== `value.py`

```python
# %% Three inputs, plain floats: nudge one, freeze the others
a, b, c = 2.0, -3.0, 10.0
d = a * b + c
print(d)  # 4.0

h = 0.0001
print(((a + h) * b + c - d) / h)  # -3.000000000010772, dd/da = b
print((a * (b + h) + c - d) / h)  # 2.0000000000042206, dd/db = a
print((a * b + (c + h) - d) / h)  # 0.9999999999976694, dd/dc = 1
```

```python
# %% The class
import math


class Value:
    """A number that remembers how it was computed."""

    def __init__(self, data, _children=(), _op="", label=""):
        """Value(2.0) is an input: no parents, no operation."""
        self.data = data
        self._prev = set(_children)  # the Value objects, not their numbers
        self._op = _op
        self.label = label

    def __repr__(self):
        """What print shows: the value only, not the parents."""
        return f"Value(data={self.data})"

    def __add__(self, other):
        """self + other, keeping both parents."""
        other = other if isinstance(other, Value) else Value(other)
        return Value(self.data + other.data, (self, other), "+")

    def __radd__(self, other):
        """3 + Value: int.__add__ gives up, so Python calls this."""
        return self + other

    def __mul__(self, other):
        """self * other, keeping both parents."""
        other = other if isinstance(other, Value) else Value(other)
        return Value(self.data * other.data, (self, other), "*")

    def __rmul__(self, other):
        """3 * Value, the 2 * u puzzle from lesson 1."""
        return self * other

    def __sub__(self, other):
        """self - other, built from + and *."""
        return self + other * -1

    def __pow__(self, k):
        """self ** k, with k a plain number, so not a parent."""
        return Value(self.data**k, (self,), f"**{k}")

    def tanh(self):
        """tanh(x) = (e^2x - 1) / (e^2x + 1), with one parent."""
        e = math.exp(2 * self.data)
        return Value((e - 1) / (e + 1), (self,), "tanh")
```

```python
# %% Checks
a = Value(2.0, label="a")
b = Value(-3.0, label="b")
c = Value(10.0, label="c")
e = a * b
e.label = "e"
d = e + c
d.label = "d"
print(d)  # Value(data=4.0)
print(d._op)  # +
print(d._prev)  # {Value(data=10.0), Value(data=-6.0)}, in any order
print(a._prev)  # set()


# %% Stretch: print the graph
def show(v, depth=0):
    """Print v, then what it was computed from, indented."""
    op = f" ({v._op})" if v._op else ""
    print("  " * depth + f"{v.label} = {v.data}{op}")
    for parent in v._prev:
        show(parent, depth + 1)


show(d)  # the five lines of step 4, siblings in any order

# %% Homework checks
print(Value(2.0) + 3, Value(2.0) * 3)  # Value(data=5.0) Value(data=6.0)
print(3 + Value(2.0), 3 * Value(2.0))  # Value(data=5.0) Value(data=6.0)
print(Value(5.0) - Value(3.0))  # Value(data=2.0)
print(Value(3.0) ** 2)  # Value(data=9.0)
print(Value(0.8813735870195432).tanh())  # Value(data=0.7071067811865476)
print(Value(3.0).tanh(), math.tanh(3.0))  # 0.9950547536867305 for both
```

== Points to compare

#ask[`_prev` is built with `set(_children)`. A tuple works too. What would change?]

#expect[
  Nothing for this lesson. A set forgets the order and keeps one copy of a parent used twice, as in `a + a`. Lesson 3 copes with both; micrograd uses a set.
]

#ask[`__sub__` is one line and has no `Value(...)` in it. How does `Value(5.0) - 3` still build a graph?]

#expect[
  `3 * -1` is a plain `-3`, and `self + -3` goes through `__add__`, which wraps it. With `Value(3.0)` instead, `other * -1` goes through `__mul__`. Both paths reuse operations that already record their parents, which is why the homework order matters.
]
