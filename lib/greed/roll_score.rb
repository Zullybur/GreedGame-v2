module Greed
  class RollScore

    def initialize(dice)
      raise ArgumentError, "Valid dice array not provided" unless dice.is_a?(Array) && dice.all? { |die| die.class == Die }
      @dice = dice
    end

    def non_scoring_dice
      array = []
      dice_to_hash.each do |face, dice|
        num_non_scoring(face, dice).times { array << dice.pop.dup }
      end
      array
    end

    def value
      dice_to_hash.inject(0) do |score, (face, dice)|
        # Score is points-from-triples + points-from-individuals
        score + triples_score(face, dice.count) + individual_die_score(face, dice.count)
      end
    end

    private
    ScoringSet = 3
    attr_reader :dice

    # non scoring dice exclude any face value that returns an individual
    # score, and sets of three dice otherwise
    def num_non_scoring(face, dice)
      face == 1 || face == 5 ? 0 : dice.size % ScoringSet
    end

    # Convert a dice collection to a hash containing arrays
    # of dice collected by face value
    def dice_to_hash
      hash = Hash.new { |h,k| h[k] = Array.new }
      dice.each { |die| hash[die.value] << die }
      hash
    end

    # 100 points for each 1 (not in a set of three)
    # 50 points for each 5 (not in a set of three)
    def individual_die_score(face, count)
      count %= ScoringSet
      case face
      when 1 then count * 100
      when 5 then count * 50
      else 0
      end
    end

    # (100 * face value) points for any set of three
    def triples_score(face, count)
      # Three 1's is worth 1000, not 100
      face = 10 if face == 1
      triple_score = (count / ScoringSet) * (100 * face)
    end
  end
end
