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
      assert_not_nil roll.score
      assert_not_nil roll.live_dice
    end

    def test_roll_calculates_score
      roll = Roll.new(Array.new(5) { Die.new })
      puts "Manual check (rolled dice):"
      roll.dice.each { |die| puts die.value }
      puts "Manual check (live dice):"
      roll.live_dice.each { |die| puts die.value }
    end
  end
end
