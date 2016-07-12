require 'greed/turn'
require 'pry'

module Greed
  class Game
    class NoPlayersError < RuntimeError
    end

    attr_reader :current_player, :players

    def initialize(players)
      # Ensure we can use what we were given
      raise ArgumentError unless players.is_a?(Array) && players.count > 0 && players.all? { |p| p.is_a?(Player) }

      @players = players
      @active_players = Array.new(players)
    end

    def next_turn!
      @active_players.push(current_player) unless final_round? || current_player.nil?
      @current_player = active_players.shift

      raise NoPlayersError if current_player.nil?
      @current_turn = Turn.new
    end

    def end_turn!
      raise RuntimeError, "There is no active turn" if current_turn.nil?
      current_player.score += current_turn.total_score if current_player.score > 0 || current_turn.total_score >= 300
      # Return current turn but prevent ending the same turn repeatedly
      current_turn.tap { @current_turn = nil }
    end

    def final_round?
      players.any? { |player| player.score >= 3000 }
    end

    private
    attr_reader :active_players, :current_turn
  end
end
