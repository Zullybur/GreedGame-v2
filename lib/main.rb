require 'greed/turn'
require 'greed/player'
require 'pry'

module Greed
  @state = "main_menu"
  DecorativeLine =  "~~~~~~~~~~~~~~~~~"

  class << self
    def display_main_menu
      @state = loop do
        system('clear')
        puts "Welcome to Greed!\n#{DecorativeLine}"
        puts "(R)ules ~~ (P)lay"
        input = get_char_input.upcase
        break "rules" if input == "R"
        break "init_game" if input == "P"
      end
    end

    def display_rules
      system('clear')
      system('cat GREED_RULES.txt | more')
      @state = loop do
        puts "#{DecorativeLine}\n(M)ain Menu"
        break "main_menu" if get_char_input.upcase == "M"
      end
    end

    def display_get_num_players_get_response
      system('clear')
      puts "Please enter the number of players (between 1 and 9):"
      get_int_input(1,9)
    end

    def display_get_players_get_response(num)
      players = []
      (1..num).each do |player_num|
        puts "\nEnter the name for player ##{player_num}:"
        name = get_string_input(30)
        players.unshift(Player.new(name))
      end
      players
    end

    def display_game_state(current_player)
      system('clear')
      puts "Current Player: #{current_player.name} (#{current_player.score})\n#{DecorativeLine}"
      puts "Scores (next player at top)"
      @active_players.reverse.each { |player| puts "#{player.name}: #{player.score}" }
      puts "#{DecorativeLine}\nPress ENTER to continue"
      gets
    end

    def display_roll_get_decision(player, turn, roll)
      loop do
        system('clear')
        puts "Current Player: #{player.name}"
        puts "Current Score: #{player.score}"
        puts "Last Roll: #{turn.dice.map { |die| die.value } }"
        puts "Roll Score: #{roll.score}"
        puts "Accumulated Score: #{turn.total_score}"
        puts DecorativeLine
        puts "You have #{turn.live_dice.size} live dice (#{turn.live_dice.map { |die| die.value } }). Would you like to roll again?"
        puts DecorativeLine
        puts "(R)oll ~~ (E)nd Turn ~~ (G)ame State"
        input = get_char_input.upcase
        break input if input == "R" || input == "E"
        display_game_state(player) if input == "G"
      end
    end

    def display_player_busted(player, turn, roll)
      system('clear')
      puts "You busted!!!"
      puts "Roll: #{turn.dice.map { |die| die.value } }\n#{DecorativeLine}"
      puts "Press ENTER to switch to the next player"
      gets
    end

    def display_final_round_warning(player, state)
      system('clear')
      puts "WARNING: #{player.name}, this is your last turn!"
      puts "The current high score is: #{state.sort.reverse[0].score}"
      puts "#{DecorativeLine}\nPress ENTER to conitnue"
      gets
    end

    def display_game_results(final_state)
      @state = loop do 
        system('clear')
        puts "Final Scores\n#{DecorativeLine}"
        final_state.sort.reverse.each { |player| puts "#{player.name}: #{player.score}" }
        puts DecorativeLine
        puts "Would you like to play again?"
        puts "(Y)es ~~ (N)o"
        input = get_char_input.upcase
        break "main_menu" if input == "Y"
        break "exit" if input == "N"
      end
    end

    def get_char_input
      loop do
        input = gets.chomp
        break input[0] if input.size > 0
      end
    end

    def get_int_input(min=nil, max=nil)
      loop do
        input = gets.chomp
        error = get_num_input_error(min, max)
        begin
          input = Integer(input)
        rescue ArgumentError
          puts "Please enter a number #{error}: "
          next
        end
        break input if (min.nil? || input >= min) && (max.nil? || input <= max)
      end
    end

    def get_num_input_error(min, max)
      string = if min.nil?
                 "smaller than or equal to #{max}"
               elsif max.nil?
                 "greater than or equal to #{min}"
               else
                 "between #{min} and #{max} inclusive"
               end
    end

    def get_string_input(max)
      gets.chomp[0..max]
    end

    def play_turn(player)
      turn = Turn.new
      loop do
        begin
          roll = turn.roll!
        rescue Turn::TurnBustError
          display_player_busted(player, turn, roll)
          break
        end
        if display_roll_get_decision(player, turn, roll) == "E"
          player.score += turn.total_score if player.score > 0 || turn.total_score >= 300
          break
        end
      end
    end
  end


  @active_players = []
  final_player_state = []

  while true
    case @state
    when "main_menu" then display_main_menu
    when "rules" then display_rules
    when "init_game"
      num_players = display_get_num_players_get_response
      @active_players = display_get_players_get_response(num_players)
      @state = "play_turns"
    when "play_turns"
      @state = loop do
        current_player = @active_players.pop
        play_turn(current_player)
        if current_player.score >= 3000
          final_player_state << current_player
          break "final_round"
        end
        @active_players.unshift(current_player)
      end
    when "final_round"
      while @active_players.size > 0
        current_player = @active_players.pop
        display_final_round_warning(current_player, final_player_state)
        play_turn(current_player)
        final_player_state << current_player
      end
      @state = "results"
    when "results"
      display_game_results(final_player_state)
    when "exit"
      break # End program
    else 
      puts "Sanity check failed - illegal state (#{@state})"
      break # End program
    end
  end
end
