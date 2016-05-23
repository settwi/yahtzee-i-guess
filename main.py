"""
OVERARCHING GAME ENGINE

die object
score card class
 - scoring box object
   - maybe method like canScore(dice: [Die]) -> Boolean { // ... }
   - can_score(dice: list) -> bool: # ...

how to organize dice?
 - scorecard
 - interact with dice
 - dice are independent!
 - really only need one set of dice

 - rounds. because yes
 - roll all five dice
 - don't return already scored boxes
 - yahtzee bonus

 """

from YahtzeeGameLogic import *
from SixSidedDie import SixSidedDie
from YahtzeeScoringCard import YahtzeeScoringCard, ScoreError


def test_scoring_cards():
    dice = list(SixSidedDie() for _ in range(5))
    for die in dice:
        die.roll()

    scoring_card = YahtzeeScoringCard()

    print(list(d.side for d in dice))

    print(scoring_card.retrieve_scores(dice))
    print(scoring_card.total_score())


def print_score_card(card: YahtzeeScoringCard):
    print_scores(card.scores)


def print_scores(scores: dict):
    for side in ('top', 'bottom'):
        for score_type, score in scores[side].items():
            print("{} - {:d}".format(score_type, score if score != -1 else 0))
        print()


def ask_dice_indices(dice: list) -> list:
    print("Choose the dice to roll"
          "\nSeparate list with spaces")
    print("Indices: ", end='')
    for i in range(len(dice)):
        print("{:d}".format(i), end=' ')
    print("\nDice:    ", end='')
    for die in dice:
        print("{:d}".format(die), end=' ')
    print()

    return list(int(x) for x in input().split(' ') if x.isdigit())


def test_game_logic():
    try:
        num_players = 2
        game_logic = YahtzeeGameLogic(num_players)

        print("Yahtzee test")
        while not game_logic.game_over:
            option = input(
                ("What would you like to do, Player {:d}?"
                    "\n\tRound {:d}"
                    "\n\tCurrent dice: {}"
                    "\n\t1 Check score card"
                    "\n\t2 Roll"
                    "\n\t3 Score Roll"
                    "\n\t4 Exit"
                    "\n\n\tRolls remaining: {:d}"
                    "\n").format(
                        game_logic.num_rounds,
                        game_logic.current_player,
                        str(game_logic.int_dice),
                        game_logic.rolls_remaining)
            )
            try:
                option = int(option)
            except ValueError as e:
                print(e)
                continue
            if option == 1:
                print("Current Card:")
                print_score_card(game_logic.current_score_card)

            if option == 2:
                if game_logic.rolls_remaining == 0:
                    print("You may only roll thrice")
                    continue
                if game_logic.rolls_remaining == 3:
                    print("First turn\n"
                          "Rolling all dice")
                    game_logic.roll_dice([0, 1, 2, 3, 4])
                else:
                    dice_roll_indices = ask_dice_indices(game_logic.int_dice)
                    game_logic.roll_dice(dice_roll_indices)

            if option == 3:
                if game_logic.rolls_remaining == 3:
                    print("Roll at least once before scoring")
                    continue
                print("What would you like to score?")
                print_scores(game_logic.potential_scores)
                which = input()
                try:
                    game_logic.score_roll(which)
                except ScoreError as e:
                    print('\n'.join(e.args))
                else:
                    game_logic.next_turn()

            if option == 4:
                if 'y' in input("Are you sure? (yes/no) ").lower():
                    break

        print("| Total Scores |")
        for i, score_triple in enumerate(game_logic.total_scores()):
            top, bonus, bottom = score_triple
            print(
                ("Player {:d}'s Score:\n"
                    "Top: {:d}\n"
                    "Bonus: {:d}\n"
                    "Bottom: {:d}\n"
                    "____________________\n"
                    "Total: {:d}\n").format(i + 1, top, bonus, bottom, sum(score_triple))
            )
    except Exception as e:
        print(e)

test_game_logic()
