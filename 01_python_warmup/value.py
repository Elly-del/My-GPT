import math


def g(a, b, c):
    d = a * b + c
    return d


def pente_a(a, b, c, h):
    der = (g(a + h, b, c) - g(a, b, c)) / h
    return der


print(pente_a(2, -3, 10, 0.00001))


def mult(x, y=2):
    return x * y


print(mult(5, 3), mult(5))


class Value:
    def __init__(self, vlr, prt=[], op="", label=""):
        self.vlr = vlr
        self.prt = prt
        self.op = op
        self.label = label

    def __repr__(self):
        # return "Value(data=" + str(self.vlr) + ")"
        return (
            f"Value(data={self.vlr}, prt={self.prt}, op={self.op}, label={self.label})"
        )

    def __add__(self, other):
        if not isinstance(other, Value):
            other = Value(other)
        vlr = self.vlr + other.vlr
        prt = [self, other]
        op = "+"
        return Value(vlr, prt, op)

    def __radd__(self, other):
        return self.__add__(other)

    def __mul__(self, other):
        if not isinstance(other, Value):
            other = Value(other)
        return Value(self.vlr * other.vlr, [self, other], "*")

    def __rmul__(self, other):
        return self * other

    def __sub__(self, other):
        return self + other * (-1)

    def __pow__(self, k):
        return Value(self.vlr**k, [self], f"**{k}")

    def tanh(self):
        e = math.exp(2 * self.vlr)
        return Value((e - 1) / (e + 1), [self], "tanh")


def show(v, depth=0):
    print(f"{'  ' * depth}{v.label}={v.vlr} {v.op}")
    for prt in v.prt:
        show(prt, depth + 1)


# %% Checks
a = Value(2.0, label="a")
b = Value(-3.0, label="b")
c = Value(10.0, label="c")
e = a * b
e.label = "e"
d = e + c
d.label = "d"
print(show(d))
