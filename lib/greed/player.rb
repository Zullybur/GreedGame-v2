module Greed
  class Player
    include Comparable

    attr_accessor :score
    attr_reader :number
    attr_reader :name

    @@count = 0

    def self.count
      @@count
    end

    def initialize(name)
      @name = name
      @score = 0
      set_number
    end

    def <=>(other)
      @score <=> other.score
    end

    def inspect
      return "P#{@number}(#{@name}): #{@score}"
    end

    private
    def set_number
      @@count = @@count + 1
      @number = @@count
    end
  end
end
