require 'greed/roll_score'

module Greed
  class Roll
    attr_reader :dice

    # Roll each of the dice provided
    def initialize(dice)
      @dice = dice.each { |die| die.roll }
      @roll_score = RollScore.new(@dice)
    end

    # Get the score of the 
    def score
      @roll_score.value
    end

    def live_dice
      @roll_score.non_scoring_dice
    end
  end
end
