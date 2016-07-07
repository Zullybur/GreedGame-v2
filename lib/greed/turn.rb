require 'greed/roll'
require 'greed/die'

module Greed
  class Turn
    attr_reader :dice, :live_dice, :total_score, :roll_score

    def initialize
      @live_dice = Array.new(5) { Die.new }
      @total_score = 0
    end

    def roll
      @roll_result = Roll.new(@live_dice)
      @dice = @roll_result.dice
      @roll_score = @roll_result.score
      update_live_dice
      update_total_score
    end

    private
    # Get live dice from roll, if no live dice remain then
    # create five new dice for the player to roll.
    def update_live_dice
      @live_dice = if @roll_result.live_dice.size > 0
                     @roll_result.live_dice
                   else
                     Array.new(5) { Die.new }
                   end
    end

    def update_total_score
      @total_score = if @roll_score > 0
                       @total_score + @roll_score
                     else
                       0
                     end
    end
  end
end
