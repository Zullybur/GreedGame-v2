require 'lib/greed/game'
require 'lib/greed/player'
require 'test/unit'
require 'pry'

module Greed
  class TurnTest < Test::Unit::TestCase

    def test_game_can_be_created
      assert_not_nil Game.new([Player.new("1"), Player.new("2")])
    end
    
    def test_game_requires_array_of_players
      assert_raise(ArgumentError) { Game.new }
      assert_raise(ArgumentError) { Game.new Player.new("1") }
      assert_raise(ArgumentError) { Game.new []}
      assert_raise(ArgumentError) { Game.new [1]}
      assert_nothing_raised(ArgumentError) { Game.new [Player.new("1")] }
    end

    def test_next_turn_returns_a_turn
      game = Game.new([Player.new("1"), Player.new("2")])
      assert_equal Turn, game.next_turn!.class
    end

    def test_end_turn_throws_runtime_error_if_no_turn_started
      game = Game.new([Player.new("1"), Player.new("2")])
      assert_raise(RuntimeError) { game.end_turn! }
      game.next_turn!
      game.end_turn!
      assert_raise(RuntimeError) { game.end_turn! }
    end

    def test_end_turn_returns_current_turn
      game = Game.new([Player.new("1"), Player.new("2")])
      turn = game.next_turn!
      begin
        turn.roll!
      rescue Turn::TurnBustError
      end
      assert_equal turn, game.end_turn!
    end

    def test_final_round_returns_correct_state
      game = Game.new([Player.new("1"), Player.new("2")])
      turn = game.next_turn!
      assert_equal false, game.final_round?

      # Get a score of 3000 from the first turn
      def turn.total_score
        3000
      end

      game.end_turn!
      assert_equal true, game.final_round?
    end
  end
end
