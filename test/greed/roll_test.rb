require 'lib/greed/roll.rb'
require 'lib/greed/die.rb'
require 'test/unit'

module Greed
  class RollTest < Test::Unit::TestCase

    def test_roll_can_be_created
      roll = Roll.new(Array.new(5) { Die.new })
      assert_not_nil roll
    end

    def test_roll_has_attributes
      roll = Roll.new(Array.new(5) { Die.new })
      assert_not_nil roll.dice
      assert roll.dice.size > 0
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

    def test_to_hash_returns_hash
      roll = Roll.new(Array.new(5) { Die.new })
      assert_equal Hash, roll.to_hash.class
    end

    def test_to_hash_returns_arrays_of_dice_as_values
      roll = Roll.new(Array.new(5) { Die.new })
      roll.to_hash.each do |key, array_of_dice|
        assert_equal Array, array_of_dice.class
        array_of_dice.each do |die|
          assert_equal Die, die.class
        end
      end
    end
  end
end
