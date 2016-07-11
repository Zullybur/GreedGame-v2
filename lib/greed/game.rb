require 'greed/turn'
require 'pry'

module Greed
  class Game
    class NoPlayersError < RuntimeError
    end

    attr_accessor :num_players, :active_players 
    attr_reader :final_player_states, :current_player, :turn, :roll

    def initialize
      @active_players = []
      @final_player_states = []
    end

    def next_player!
      @current_player = active_players.pop
      raise NoPlayersError if current_player.nil?
      @turn = Turn.new
    end

    def play_turn!
      begin
        @roll = turn.roll!
        "get roll decision"
      rescue Turn::TurnBustError
        "busted turn"
      end
    end

    def end_turn!(update_score=true)
      update_player_score if update_score
      if current_player.score >= 3000
        final_player_states.push(current_player)
        "trigger final round"
      else
        make_current_player_active
        "start new turn"
      end
    end

    def end_final_turn!(update_score=true)
      update_player_score if update_score
      final_player_states.push(current_player)
      "start new turn"
    end

    private
    def make_current_player_active
      active_players.unshift(current_player)
    end

    def update_player_score
      current_player.score += turn.total_score if current_player.score > 0 || turn.total_score >= 300
    end
  end
end
