require 'lib/greed/turn'
require 'test/unit'
require 'pry'

module Greed
  class TurnTest < Test::Unit::TestCase

    def test_turn_can_be_created
      assert_not_nil Turn.new
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

    def test_roll_returns_a_roll
      loop do
        begin
          roll = Turn.new.roll!
          assert_equal Roll, Turn.new.roll!.class
          break
        rescue Turn::TurnBustError
        end
      end
    end

    def test_zero_roll_score_busts_turn
      # set up test
      turn = Turn.new
      def turn.new_dice
        []
      end
      assert_raise(Turn::TurnBustError) { turn.roll! }
    end

    def test_dice_returns_five_new_dice_if_no_rolls
      turn = Turn.new
      assert_equal 5, turn.dice.size
      assert turn.dice.all? { |die| die.value == nil }
    end

    def test_dice_returns_dice_from_last_roll
      turn = Turn.new
      loop do
        begin
          roll = turn.roll!
          assert_equal roll.dice, turn.dice
          break
        rescue Turn::TurnBustError
        end
      end
    end
        
    def test_no_live_dice_creates_five_new_dice
      turn = Turn.new
      def turn.roll_result
        Roll.new([])
      end
      assert_equal 5, turn.live_dice.count
      turn.live_dice.each { |die| assert_equal Die, die.class }
    end

    def test_total_score_returns_accumulated_score
      turn = Turn.new
      rolls = []
      5.times do
        begin
          roll = turn.roll!
          rolls.push roll
        rescue Turn::TurnBustError
          rolls.push(Roll.new([]))
        end
      end
      assert_equal rolls.map(&:score).reduce(0, &:+), turn.total_score
    end
  end
end
