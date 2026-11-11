import math


class Value:
    def __init__(self, vlr, prt=None, op="", label=""):
        self.vlr = vlr
        self.prt = prt
        self.op = op
        self.label = label
        self.grad = 0.0

    def __repr__(self):
        # return "Value(data=" + str(self.vlr) + ")"
        return f"Value(data={self.vlr, self.grad}, prt={self.prt}, op={self.op}, label={self.label})"

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
    print(f"{'  ' * depth}{v.label}={v.vlr} {v.op} grad={v.grad}")
    if v.prt:
        for prt in v.prt:
            show(prt, depth + 1)


a = Value(2, label="a")
b = Value(-3, label="b")
c = Value(10, label="c")
e = a * b
e.label = "e"
d = e + c
d.label = "d"
f = Value(-2, label="f")
L = d * f
L.label = "L"
print(L)
L.grad = 1
f.grad = d.vlr * L.grad
d.grad = f.vlr * L.grad
e.grad = d.grad
c.grad = d.grad
a.grad = b.vlr * e.grad
b.grad = a.vlr * e.grad
show(L)
a.vlr += 0.001 * a.grad
b.vlr += 0.001 * b.grad
c.vlr += 0.001 * c.grad
f.vlr += 0.001 * f.grad
e = a * b
d = e + c
L = d * f
print(L)
show(L)
