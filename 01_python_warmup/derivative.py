def f(x):
    img = 3 * x * x - 4 * x + 5
    return img


print(f(1), f(2), f(3))


def pente(x, h):
    der = (f(x + h) - f(x)) / h
    return der


print(pente(-3.0, 0.000001))


def tangente(x):
    y = 20 + 14 * (x - 3)
    return y


# %% Plot f and its tangent at x = 3
import matplotlib.pyplot as plt

xs = [i / 10 for i in range(-20, 61)]  # x from -2 to 6, step 0.1
plt.plot(xs, [f(x) for x in xs], label="f")
plt.plot(xs, [tangente(x) for x in xs], label="tangent at x = 3")
plt.scatter([3], [f(3)], color="red", zorder=3)  # the point (3, 20)
plt.legend()
plt.grid(True)
plt.show()
