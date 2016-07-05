module Greed
  class Die
    attr_reader :value, :sides

    # Create a die with a specified number of sides.
    # Uses a six sided die as default if not provided.
    def initialize(sides=6)
      @sides = sides
    end

    # Roll the die and get the value
    def roll
      @value = rand(1..@sides)
    end
  end
end
