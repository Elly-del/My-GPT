def g(a, b, c):
    d = a * b + c
    return d


def pente_a(a, b, c, h):
    der = (g(a + h, b, c) - g(a, b, c)) / h
    return der


print(pente_a(2, -3, 10, 0.00001))
