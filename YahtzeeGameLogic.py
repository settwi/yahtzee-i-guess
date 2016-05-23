from SixSidedDie import SixSidedDie
from YahtzeeScoringCard import YahtzeeScoringCard, ScoreError


class RollError(Exception):
    pass


class GameOverException(Exception):
    pass


class YahtzeeGameLogic:
    """Logic API thing for a Python Yahtzee game
    """
    def __init__(self, num_players=1):
        self.dice = tuple(SixSidedDie() for _ in range(5))
        self._score_cards = tuple(YahtzeeScoringCard() for _ in range(num_players))
        # used to keep track of whose turn it is
        self.num_players = num_players
        self.turn = 0
        self.players_gone = 0
        self.game_over = False
        # min is 0
        self.rolls_remaining = 3

    @property
    def int_dice(self):
        return list(d.side for d in self.dice)

    @property
    def current_player(self):
        return self.turn + 1

    @property
    def current_score_card(self):
        return self._score_cards[self.turn]

    @property
    def potential_scores(self):
        return self._score_cards[self.turn].retrieve_scores(self.int_dice)

    @property
    def num_rounds(self):
        return self.players_gone // self.num_players

    def next_turn(self):
        if self.game_over:
            raise GameOverException("Cannot switch turn; game over")

        self.turn = (self.turn + 1) % self.num_players
        self.rolls_remaining = 3
        self.players_gone += 1

        if self.num_rounds == 13:
            self.game_over = True

    def roll_dice(self, which_dice: list) -> list:
        """
        :param which_dice: indices of dice to roll
        """
        if self.rolls_remaining == 3:
            which_dice = tuple(x for x in range(5))
        if len(which_dice) == 0:
            raise RollError("Need to provide legit list of dice to roll")
        if self.rolls_remaining == 0:
            raise RollError("Cannot roll more than three times")
        if self.game_over:
            raise GameOverException("can't roll; game over")

        for idx in which_dice:
            self.dice[idx].roll()
        '''
        for die, hack in zip(self.dice, [3, 6, 4, 4, 5]):
            die.side = hack
        '''
        self.rolls_remaining -= 1

    def score_roll(self, which: str):
        if self.rolls_remaining == 3:
            raise ScoreError("Must roll at least once to score")
        self._score_cards[self.turn].score_roll(self.int_dice, which)

    def total_scores(self) -> list:
        return [sc.total_score() for sc in self._score_cards]