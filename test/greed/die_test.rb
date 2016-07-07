require 'lib/greed/die.rb'
require 'test/unit'

module Greed
  class DieTest < Test::Unit::TestCase

    def test_default_die_size_is_six
      die = Die.new
      assert_not_nil die
      assert_equal 6, die.sides
    end

    def test_roll_returns_random_value
      die = Die.new
      rolls = Hash.new{0}
      1000.times do
        rolls[die.roll] += 1
      end
      assert_equal 6, rolls.size
    end

    def test_die_size_can_be_set
      die = Die.new(20)
      assert_equal 20, die.sides
      rolls = Hash.new(0)
      1000.times do
        rolls[die.roll] += 1
      end
      assert_equal 20, rolls.size
      assert_equal 20, rolls.keys.max
    end
  end
end
