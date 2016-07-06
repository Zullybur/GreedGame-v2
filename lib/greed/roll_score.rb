module Greed
  class RollScore
    attr_reader :value

    def initialize(dice)
      raise ArgumentError, "Valid roll object not provided" unless dice
      @dice = dice
      @value = calculate_score
    end

    def non_scoring_dice
      non_scoring_dice = []
      dice_to_hash.each do |face, dice|
        # live dice are dice that do not contribute to the score
        if face != 1 && face != 5
          (dice.size % 3).times do
            non_scoring_dice << dice.pop
          end
        end
      end
      # Create 5 new dice if no live dice remain
      if non_scoring_dice.size == 0 then non_scoring_dice = Array.new(5) { Die.new } end
      non_scoring_dice
    end

    private
    # Convert a dice collection to a hash containing arrays
    # of dice collected by face value
    def dice_to_hash
      hash = Hash.new { |h,k| h[k] = Array.new }
      @dice.each do |die|
        hash[die.value] << die
      end
      hash
    end

    def calculate_score
      dice_to_hash.inject(0) do |score, (face, dice)|
        # Score is points-from-triples + points-from-individuals
        score + triples_score(face, dice.size) + individual_die_score(face, dice.size)
      end
    end

    # 100 points for each 1 (not in a set of three)
    # 50 points for each 5 (not in a set of three)
    def individual_die_score(face, count)
      count %= 3
      case face
      when 1 then (count % 3) * 100
      when 5 then (count % 3) * 50
      else 0
      end
    end

    # (100 * face value) points for any set of three
    def triples_score(face, count)
      # Three 1's is worth 1000, not 100
      face = 10 if face == 1
      triple_score = (count / 3) * (100 * face)
    end
  end
end
