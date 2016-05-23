from ScoringBoxes import *


class ScoreError(Exception):
    pass


class YahtzeeScoringCard:
    """Scoring card for a player in Yahtzee.
    """
    def __init__(self):
        # dict of ScoringBox objects
        self.scoring_boxes = {'top': dict(), 'bottom': dict()}
        # dict of ints to keep track of scores
        self.scores = {'top': dict(), 'bottom': dict()}

        num_names = ("Ones", "Twos", "Threes", "Fours", "Fives", "Sixes")
        for i, name in enumerate(num_names):
            self.scoring_boxes['top'][name] = NumScoringBox(name, i + 1)

        self.scoring_boxes['bottom']['3 of A Kind'] = ThreeOfAKindScoringBox("3 of A Kind")
        self.scoring_boxes['bottom']['4 of A Kind'] = FourOfAKindScoringBox("4 of A Kind")
        self.scoring_boxes['bottom']['Full House'] = FullHouseScoringBox("Full House")
        self.scoring_boxes['bottom']['Small Straight'] = SmallStraightScoringBox("Small Straight")
        self.scoring_boxes['bottom']['Large Straight'] = LargeStraightScoringBox("Large Straight")
        self.scoring_boxes['bottom']['YAHTZEE'] = YahtzeeScoringBox("YAHTZEE")
        self.scoring_boxes['bottom']['Chance'] = ChanceScoringBox("Chance")

        for side, boxes in self.scoring_boxes.items():
            for box_key, box in boxes.items():
                self.scores[side][box_key] = -1

    def retrieve_scores(self, dice: list) -> dict:
        """
        :param dice: list of integer dice
        """
        scorable = {'top': dict(), 'bottom': dict()}

        for side, boxes in self.scoring_boxes.items():
            for box_key, box in boxes.items():
                scorable[side][box_key] = box.score_dice(dice)

        return scorable

    def score_roll(self, dice: list, which: str):
        scorable = self.retrieve_scores(dice)

        side = 'top'
        if which not in scorable[side].keys():
            side = 'bottom'

        try:
            if self.scores[side][which] == -1:
                self.scores[side][which] = scorable[side][which]
            else:
                raise ScoreError("Cannot score already-scored box")
        except KeyError as e:
            raise ScoreError("Unknown scoring box", which) from e

    def total_score(self) -> tuple:
        top_score = sum((s if s != -1 else 0) for s in self.scores['top'].values())
        bottom_score = sum((s if s != -1 else 0) for s in self.scores['bottom'].values())
        bonus = 35 if top_score >= 63 else 0

        return top_score, bonus, bottom_score
