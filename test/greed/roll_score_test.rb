require 'lib/greed/roll_score'
require 'lib/greed/die'
require 'test/unit'

module Greed
  class RollScoreTest < Test::Unit::TestCase

    def test_argument_error_when_nil_passed
      assert_raise(ArgumentError) do
        RollScore.new(nil)
      end
    end

    def test_score_of_an_empty_list_is_zero
      roll_score = RollScore.new([])
      assert_equal 0, roll_score.value
    end

    def test_live_dice_reset_to_five_when_all_dice_score
      dice = [Die.new]
      dice[0].instance_eval('@value = 5')
      roll_score = RollScore.new(dice)
      assert_equal 5, roll_score.non_scoring_dice.size
      roll_score.non_scoring_dice.each do |die|
        assert_equal Die, die.class
      end
    end

    def test_score_of_a_single_roll_of_5_is_50
      dice = [Die.new]
      dice[0].instance_eval('@value = 5')
      roll_score = RollScore.new(dice)
      assert_equal 50, roll_score.value
    end

    def test_score_of_a_single_roll_of_1_is_100
      dice = [Die.new]
      dice[0].instance_eval('@value = 1')
      roll_score = RollScore.new(dice)
      assert_equal 100, roll_score.value
    end

    def test_score_of_multiple_1s_and_5s_is_the_sum_of_individual_scores
      dice = Array.new(4) { Die.new }
      dice.each_with_index do |die, i|
        (i % 2 == 0) ? die.instance_eval('@value = 1') : die.instance_eval('@value = 5')
      end
      roll_score = RollScore.new(dice)
      assert_equal 300, roll_score.value
    end

    def test_score_of_single_2s_3s_4s_and_6s_are_zero
      dice = Array.new(3) { Die.new }
      dice.each_with_index { |die, i| die.instance_eval('@value = i + 2') }
      dice << Die.new
      dice[3].instance_eval('@value = 6')
      roll_score = RollScore.new(dice)
      assert_equal 0, roll_score.value
    end

    def test_single_2s_3s_4s_and_6s_all_dice_are_live
      dice = Array.new(3) { Die.new }
      dice.each_with_index { |die, i| die.instance_eval('@value = i + 2') }
      dice << Die.new
      dice[3].instance_eval('@value = 6')
      roll_score = RollScore.new(dice)
      assert_equal 4, roll_score.non_scoring_dice.size
      assert (dice.map { |die| die.value }).eql?(roll_score.non_scoring_dice.map { |die| die.value })
    end

    def test_score_of_a_triple_1_is_1000
      dice = Array.new(3) { Die.new }
      dice.each { |die| die.instance_eval('@value = 1') }
      roll_score = RollScore.new(dice)
      assert_equal 1000, roll_score.value
    end

    def test_score_of_other_triples_is_100x
      dice = Array.new(3) { Die.new }
      dice.each { |die| die.instance_eval('@value = 2') }
      roll_score = RollScore.new(dice)
      assert_equal 200, roll_score.value
      dice.each { |die| die.instance_eval('@value = 3') }
      roll_score = RollScore.new(dice)
      assert_equal 300, roll_score.value
      dice.each { |die| die.instance_eval('@value = 4') }
      roll_score = RollScore.new(dice)
      assert_equal 400, roll_score.value
      dice.each { |die| die.instance_eval('@value = 5') }
      roll_score = RollScore.new(dice)
      assert_equal 500, roll_score.value
      dice.each { |die| die.instance_eval('@value = 6') }
      roll_score = RollScore.new(dice)
      assert_equal 600, roll_score.value
    end

    def test_score_of_mixed_is_sum
      dice = Array.new(5) { Die.new }
      dice[0].instance_eval('@value = 2')
      dice[1].instance_eval('@value = 5')
      dice[2].instance_eval('@value = 2')
      dice[3].instance_eval('@value = 2')
      dice[4].instance_eval('@value = 3')
      roll_score = RollScore.new(dice)
      assert_equal 250, roll_score.value
      dice[0].instance_eval('@value = 5')
      dice[1].instance_eval('@value = 5')
      dice[2].instance_eval('@value = 5')
      dice[3].instance_eval('@value = 5')
      dice[4].instance_eval('@value = 4')
      roll_score = RollScore.new(dice)
      assert_equal 550, roll_score.value
      dice[0].instance_eval('@value = 1')
      dice[1].instance_eval('@value = 1')
      dice[2].instance_eval('@value = 1')
      dice[3].instance_eval('@value = 1')
      dice[4].instance_eval('@value = 2')
      roll_score = RollScore.new(dice)
      assert_equal 1100, roll_score.value
      dice[0].instance_eval('@value = 1')
      dice[1].instance_eval('@value = 1')
      dice[2].instance_eval('@value = 1')
      dice[3].instance_eval('@value = 1')
      dice[4].instance_eval('@value = 1')
      roll_score = RollScore.new(dice)
      assert_equal 1200, roll_score.value
      dice[0].instance_eval('@value = 1')
      dice[1].instance_eval('@value = 1')
      dice[2].instance_eval('@value = 1')
      dice[3].instance_eval('@value = 5')
      dice[4].instance_eval('@value = 1')
      roll_score = RollScore.new(dice)
      assert_equal 1150, roll_score.value
    end
  end
end
