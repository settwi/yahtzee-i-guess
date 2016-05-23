class ScoringBox:
    """
    Base class for Scoring Boxes.
    """
    def __init__(self, name: str):
        self.name = name

    def score_dice(self, dice: list) -> int:
        """Each scoring box expects a list of int not SixSidedDie
        :param dice: an integer list of dice for the turn
        """
        raise NotImplementedError


class NumScoringBox(ScoringBox):
    """Scoring box class for Ones to Sixes
    """
    def __init__(self, name: str, num: int):
        ScoringBox.__init__(self, name)
        self.num = num

    def score_dice(self, dice: list) -> int:
        for die in dice:
            if die == self.num:
                return self.num * dice.count(die)

        return 0


class XOfAKindScoringBox(ScoringBox):
    """Scoring box for 'X' of a kind
    """
    def __init__(self, name: str, of_a_kind: int):
        ScoringBox.__init__(self, name)
        self.of_a_kind = of_a_kind

    def score_dice(self, dice: list) -> int:
        for die in dice:
            if dice.count(die) >= self.of_a_kind:
                return sum(dice)

        return 0


class ThreeOfAKindScoringBox(XOfAKindScoringBox):
    def __init__(self, name):
        XOfAKindScoringBox.__init__(self, name, 3)


class FourOfAKindScoringBox(XOfAKindScoringBox):
    def __init__(self, name):
        XOfAKindScoringBox.__init__(self, name, 4)


class FullHouseScoringBox(ScoringBox):
    def __init__(self, name):
        ScoringBox.__init__(self, name)

    def score_dice(self, dice: list) -> int:
        first = dice[0]
        num_of_first = dice.count(first)

        if num_of_first == 2 or num_of_first == 3:
            num_of_other = 2
            if num_of_first == 2:
                num_of_other = 3
            for die in dice:
                if die != first and dice.count(die) == num_of_other:
                    return 25

        return 0


class SmallStraightScoringBox(ScoringBox):
    def __init__(self, name):
        ScoringBox.__init__(self, name)
        
    def score_dice(self, dice: list) -> int:
        unique_dice = list(set(sorted(dice)))

        if len(unique_dice) < 4:
            return 0

        for i in range(3):
            if unique_dice[i+1] - unique_dice[i] != 1:
                return 0

        return 30


class LargeStraightScoringBox(ScoringBox):
    def __init__(self, name):
        ScoringBox.__init__(self, name)

    def score_dice(self, dice: list) -> int:
        sorted_dice = sorted(dice)
        if sorted_dice == [1, 2, 3, 4, 5] or sorted_dice == [2, 3, 4, 5, 6]:
            return 40

        return 0


class YahtzeeScoringBox(ScoringBox):
    def __init__(self, name):
        ScoringBox.__init__(self, name)

    def score_dice(self, dice: list) -> int:
        if all(dice[0] == d for d in dice):
            return 50

        return 0


class ChanceScoringBox(ScoringBox):
    def __init__(self, name):
        ScoringBox.__init__(self, name)

    def score_dice(self, dice: list) -> int:
        return sum(dice)
