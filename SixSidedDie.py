from random import randint


class SixSidedDie:
    def __init__(self):
        self.side = randint(1, 6)

    def roll(self) -> int:
        self.side = randint(1, 6)
        return self.side
