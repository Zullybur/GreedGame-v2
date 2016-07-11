require 'lib/greed/turn'
require 'test/unit'

module Greed
  class TurnTest < Test::Unit::TestCase

    def test_turn_can_be_created
      assert_not_nil Turn.new
    end

    def test_roll_returns_a_roll
      assert_equal Roll, Turn.new.roll!.class
    end

    def test_turn_has_attributes
      turn = Turn.new
      assert_not_nil turn.dice
      assert_not_nil turn.live_dice
      assert_not_nil turn.total_score
    end

    def test_roll_score_is_zero_for_new_turn
      turn = Turn.new
      assert_equal 0, turn.total_score
    end

    def test_zero_roll_score_busts_turn
      # set up test
      turn = Turn.new
      def turn.new_dice
        []
      end
      assert_raise(Turn::TurnBustError) { turn.roll! }
    end
        
    def test_no_live_dice_creates_five_new_dice
      turn = Turn.new
      turn.roll!
      def turn.roll_result
        Roll.new([])
      end
      assert_equal 5, turn.live_dice.count
    end
  end
end
