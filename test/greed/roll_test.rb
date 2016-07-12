require 'lib/greed/roll.rb'
require 'lib/greed/die.rb'
require 'test/unit'
require 'pry'

module Greed
  class RollTest < Test::Unit::TestCase

    def test_roll_can_be_created
      roll = Roll.new(Array.new(5) { Die.new })
      assert_not_nil roll
    end

    def test_roll_throws_error_on_nill_parameter
      assert_raise(ArgumentError) do
        Roll.new(nil)
      end
    end

    def test_roll_has_attributes
      roll = Roll.new(Array.new(5) { Die.new })
      assert_not_nil roll.dice
      assert_not_nil roll.score
      assert_not_nil roll.live_dice
    end

    def test_subsequent_rolls_change_dice_values
      dice = Array.new(5) { Die.new }
      roll1 = Roll.new(dice).dice.map { |x| x.value}
      roll2 = Roll.new(dice).dice.map { |x| x.value}
      roll3 = Roll.new(dice).dice.map { |x| x.value}
      # Allow for the rare possibility of randomly rolling the
      # same values twice, by checking three arrays against each other
      assert !roll1.eql?(roll2) || !roll2.eql?(roll3) || !roll1.eql?(roll3)
    end
  end
end
