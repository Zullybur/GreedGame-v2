load 'greed/game.rb'
load 'greed/player.rb'
load 'greed/IO.rb'

include Greed

players = [Player.new("Player 1"), Player.new("Player 2")]

game = Game.new(players)


begin
  # Game loop
  while true
    turn = game.next_turn!
    Greed::IO::display_final_round_warning(game) if game.final_round?
    begin 
      # Turn loop
      while true
        roll = turn.roll!
        reroll = Greed::IO::display_reroll?(game, turn, roll)
        if !reroll
          game.end_turn!
          break
        end
      end
    rescue Turn::TurnBustError
      Greed::IO::display_player_busted(game.current_player, turn.dice)
    end
  end
rescue Game::NoPlayersError
  Greed::IO::display_game_results(game.players)
end
