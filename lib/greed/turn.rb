require 'greed/roll'

module Greed
  class Turn
    attr_reader :dice
    attr_reader :live_dice
    attr_reader :total_score
    attr_reader :roll_score

    def initialize
      @live_dice = Array.new(5) { Die.new }
      @total_score = 0
    end

    def roll
      roll = Roll.new(@live_dice)
      @dice = roll.dice
      @roll_score = roll.score
      @live_dice = roll.live_dice
      update_total_score
    end

    private
    def update_total_score
      @total_score = if @roll_score > 0
        @total_score + @roll_score
      else
        0
      end
    end
  end
end
