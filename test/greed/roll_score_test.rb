require 'lib/greed/roll_score'
require 'lib/greed/die'
require 'test/unit'

module Greed
  class RollScoreTest < Test::Unit::TestCase

    def test_roll_score_can_be_created
      assert_not_nil RollScore.new []
    end

    def test_argument_error_unless_empty_array_or_array_of_dice_received
      assert_raise(ArgumentError) { RollScore.new nil }
      assert_raise(ArgumentError) { RollScore.new Die.new.roll }
      assert_raise(ArgumentError) { RollScore.new Die.new }
      assert_raise(ArgumentError) { RollScore.new [5] }
    end

    def test_score_of_an_empty_array_is_zero
      assert_equal 0, RollScore.new([]).value
    end

    def test_empty_array_returned_when_all_die_score
      die = Die.new
      die.instance_eval('@value = 1')
      assert [].eql?(RollScore.new([die]).non_scoring_dice)
    end

    def test_score_of_a_single_roll_of_5_is_50
      die = Die.new
      die.instance_eval('@value = 5')
      assert_equal 50, RollScore.new([die]).value
    end

    def test_score_of_a_single_roll_of_1_is_100
      die = Die.new
      die.instance_eval('@value = 1')
      assert_equal 100, RollScore.new([die]).value
    end

    def test_score_of_multiple_1s_and_5s_is_the_sum_of_individual_scores
      dice = Array.new(4) { Die.new }
      dice.each_with_index do |die, i|
        (i % 2 == 0) ? die.instance_eval('@value = 1') : die.instance_eval('@value = 5')
      end
      assert_equal 300, RollScore.new(dice).value
    end

    def test_score_of_single_2s_3s_4s_and_6s_are_zero
      dice = Array.new(3) { Die.new }
      dice.each_with_index { |die, i| die.instance_eval('@value = i + 2') }
      dice.push Die.new
      dice.last.instance_eval('@value = 6')
      assert_equal 0, RollScore.new(dice).value
    end

    def test_single_2s_3s_4s_and_6s_all_dice_are_live
      dice = Array.new(3) { Die.new }
      dice.each_with_index { |die, i| die.instance_eval('@value = i + 2') }
      dice.push Die.new
      dice[3].instance_eval('@value = 6')
      assert_equal dice.map { |die| die.value }, RollScore.new(dice).non_scoring_dice.map { |die| die.value }
    end

    def test_score_of_a_triple_1_is_1000
      dice = Array.new(3) { Die.new }
      dice.each { |die| die.instance_eval('@value = 1') }
      assert_equal 1000, RollScore.new(dice).value
    end

    def test_score_of_other_triples_is_100x
      dice = Array.new(3) { Die.new }
      dice.each { |die| die.instance_eval('@value = 2') }
      assert_equal 200, RollScore.new(dice).value

      dice = Array.new(3) { Die.new }
      dice.each { |die| die.instance_eval('@value = 3') }
      assert_equal 300, RollScore.new(dice).value

      dice = Array.new(3) { Die.new }
      dice.each { |die| die.instance_eval('@value = 4') }
      assert_equal 400, RollScore.new(dice).value

      dice = Array.new(3) { Die.new }
      dice.each { |die| die.instance_eval('@value = 5') }
      assert_equal 500, RollScore.new(dice).value

      dice = Array.new(3) { Die.new }
      dice.each { |die| die.instance_eval('@value = 6') }
      assert_equal 600, RollScore.new(dice).value
    end

    def test_score_of_mixed_values_is_accurate
      dice = Array.new(5) { Die.new }
      dice[0].instance_eval('@value = 2')
      dice[1].instance_eval('@value = 5')
      dice[2].instance_eval('@value = 2')
      dice[3].instance_eval('@value = 2')
      dice[4].instance_eval('@value = 3')
      assert_equal 250, RollScore.new(dice).value

      dice = Array.new(5) { Die.new }
      dice[0].instance_eval('@value = 5')
      dice[1].instance_eval('@value = 5')
      dice[2].instance_eval('@value = 5')
      dice[3].instance_eval('@value = 5')
      dice[4].instance_eval('@value = 4')
      assert_equal 550, RollScore.new(dice).value

      dice = Array.new(5) { Die.new }
      dice[0].instance_eval('@value = 1')
      dice[1].instance_eval('@value = 1')
      dice[2].instance_eval('@value = 1')
      dice[3].instance_eval('@value = 1')
      dice[4].instance_eval('@value = 2')
      assert_equal 1100, RollScore.new(dice).value

      dice = Array.new(5) { Die.new }
      dice[0].instance_eval('@value = 1')
      dice[1].instance_eval('@value = 1')
      dice[2].instance_eval('@value = 1')
      dice[3].instance_eval('@value = 1')
      dice[4].instance_eval('@value = 1')
      assert_equal 1200, RollScore.new(dice).value

      dice = Array.new(5) { Die.new }
      dice[0].instance_eval('@value = 1')
      dice[1].instance_eval('@value = 1')
      dice[2].instance_eval('@value = 1')
      dice[3].instance_eval('@value = 5')
      dice[4].instance_eval('@value = 1')
      assert_equal 1150, RollScore.new(dice).value
    end
  end
end
