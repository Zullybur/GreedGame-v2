require 'greed/roll_score'
require 'pry'

module Greed
  class Roll
    attr_reader :dice

    # Roll each of the dice provided
    def initialize(dice)
      raise ArgumentError, "Valid dice array not provided" unless dice
      @dice = dice.each { |die| die.roll }
    end

    def score
      roll_score.value
    end

    def live_dice
      roll_score.non_scoring_dice
    end

    private
    attr_accessor :result

    def roll_score
      result ||= RollScore.new(dice)
    end
  end
end
