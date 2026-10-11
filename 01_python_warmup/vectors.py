from math import sqrt


class Vector:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __repr__(self):
        return "(" + str(self.x) + " , " + str(self.y) + ")"

    def __add__(self, other):
        return Vector(self.x + other.x, self.y + other.y)

    def norm(self):
        return sqrt(self.x**2 + self.y**2)

    def __mul__(self, nbr):
        return Vector(self.x * nbr, self.y * nbr)

    def __rmul__(self, nbr):
        return Vector(self.x * nbr, self.y * nbr)


v = Vector(4, 8)
print(v)
y = Vector(10, 32)
print(y)
w = v + y
print(w)
print(v.norm())
print(3 * v)
