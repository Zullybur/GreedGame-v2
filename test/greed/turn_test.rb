require 'lib/greed/turn'
require 'test/unit'

module Greed
  class TurnTest < Test::Unit::TestCase

    def test_turn_can_be_created
      assert_not_nil Turn.new
    end

    def test_turn_has_attributes
      turn = Turn.new
      turn.roll
      assert_not_nil turn.dice
      assert_not_nil turn.live_dice
      assert_not_nil turn.total_score
      assert_not_nil turn.roll_score
    end

    def test_total_score_accumulates
      turn = Turn.new
      turn.instance_eval('@total_score = 10')
      turn.instance_eval('@roll_score = 10')
      turn.send(:update_total_score)
      assert_equal 20, turn.total_score
    end

    def test_zero_roll_score_resets_score
      turn = Turn.new
      turn.instance_eval('@total_score = 10')
      turn.instance_eval('@roll_score = 0')
      turn.send(:update_total_score)
      assert_equal 0, turn.total_score
    end
  end
end
