require 'greed/roll'
require 'greed/die'
require 'pry'

module Greed
  class Turn
    # A turn is busted when any roll scores zero points
    class TurnBustError < RuntimeError
    end

    def initialize
      @rolls = []
    end

    def roll!
      Roll.new(live_dice).tap do |roll| 
        rolls.push roll 
        raise TurnBustError unless roll.score > 0
      end
    end

    def dice
      roll_result&.dice || new_dice
    end

    # Get live dice from roll, if no live dice remain then
    # create five new dice for the player to roll.
    def live_dice
      result = roll_result&.live_dice || new_dice
      result.size > 0 ? result : new_dice
    end

    def total_score
      rolls.map(&:score).reduce(0, &:+)
    end

    private
    attr_reader :rolls

    def roll_result
      rolls.last
    end

    def new_dice
      Array.new(5) { Die.new }
    end
  end
end
