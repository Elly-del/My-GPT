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
    def __init__(self, vlr, prt1=None, prt2=None, op=None):
        self.vlr = vlr
        self.prt1 = prt1
        self.prt2 = prt2
        self.op = op

    def __repr__(self):
        return str(self.vlr) + str(self.prt1) + str(self.op) + str(self.prt2)

    def __add__(self, other):
        vlr = self.vlr + other.vlr
        prt1 = self.vlr
        prt2 = other.vlr
        op = "+"
        return Value(vlr, prt1, prt2, op)

    def __mul__(self, other):
        return Value(self.vlr * other.vlr, self.vlr, other.vlr, "*")


a = Value(2)
b = Value(-3.0)
c = Value(10.0)
e = a * b
d = e + c
print(d)  # Value(data=4.0)
print(d.op)  # +
print(d.prt1)  # the two parents, Value(data=-6.0) and Value(data=10.0)
print(a.prt2)
