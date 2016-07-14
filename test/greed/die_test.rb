require 'lib/greed/die.rb'
require 'test/unit'

module Greed
  class DieTest < Test::Unit::TestCase

    def test_default_die_size_is_six
      die = Die.new
      assert_not_nil die
      assert_equal 6, die.sides
    end

    def test_die_roll_returns_random_value
      die = Die.new
      rolls = Hash.new{0}
      1000.times do
        rolls[die.roll] += 1
      end
      assert_equal 6, rolls.size
    end

    def test_die_size_can_be_set
      srand(1)
      # Prep results based on test with given seed
      expected_values = [6, 4, 5, 1, 2, 4, 6, 1, 1, 2]
      srand(1)
      dice_values = Array.new(10) { Die.new.roll }
      assert expected_values.eql? dice_values
    end
  end
end
