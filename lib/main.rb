require 'greed/game'
require 'greed/player'
require 'greed/IO'
require 'pry'

module Greed

  state = "main menu"

  while true
    state = case state
            when "main menu"
              IO::display_main_menu

            when "rules"
              IO::display_rules

            when "init game"
              final_round = false
              game = Game.new
              game.num_players = IO::display_get_num_players
              game.active_players = IO::display_get_players(game.num_players)
              "start new turn"

            when "start new turn"
              begin
                game.next_player!
                IO::display_final_round_warning(game) if final_round
                "play turn"
              rescue Game::NoPlayersError
                "end game"
              end

            when "play turn"
              game.play_turn!

            when "get roll decision"
              input = IO::display_get_roll_decision(game)
              if input == "E"
                final_round ? game.end_final_turn! : game.end_turn!
              elsif input == "R"
                "play turn"
              end

            when "busted turn"
              IO::display_player_busted(game)
              final_round ? game.end_final_turn!(false) : game.end_turn!(false)

            when "trigger final round"
              final_round = true
              "start new turn"

            when "end game"
              IO::display_game_results(game.final_player_states)

            when "exit"
              break # End program

            else 
              puts "Sanity check failed - illegal state (#{@state})"
              break # End program
            end
  end
end
