require 'greed/player'

module Greed
  class IO
    class << self
      DecorativeLine =  "~~~~~~~~~~~~~~~~~"

      def display_main_menu
        loop do
          system('clear')
          puts "Welcome to Greed!\n#{DecorativeLine}"
          puts "(R)ules ~~ (P)lay"
          input = get_char_input.upcase
          break input if input == "R" || input == "P"
        end
      end

      def display_rules
        system('clear')
        system('cat GREED_RULES.txt | more')
        puts "#{DecorativeLine}\nPress ENTER to return to main menu"
        gets
      end

      def display_get_num_players
        system('clear')
        puts "Please enter the number of players (between 1 and 9):"
        get_int_input(1,9)
      end

      def display_get_players(num)
        players = []
        (1..num).each do |player_num|
          puts "\nEnter the name for player ##{player_num}:"
          name = get_string_input(30)
          players.push(Player.new(name))
        end
        players
      end

      def display_game_state(game)
        system('clear')
        puts "Players (in turn order)\n#{DecorativeLine}"
        game.players.each { |player| puts "#{player.name}: #{player.score}" }
        puts "The game is #{game.final_round? ? "" : "**not**"} in the final round"
        puts "#{DecorativeLine}\nPress ENTER to continue"
        gets
      end

      def display_reroll?(game, turn, roll)
        loop do
          system('clear')
          puts "Current Player: #{game.current_player.name}"
          puts "Current Score: #{game.current_player.score}"
          puts "Last Roll: #{turn.dice.map { |die| die.value } }"
          puts "Roll Score: #{roll.score}"
          puts "Accumulated Score: #{turn.total_score}"
          puts DecorativeLine
          puts "You have #{turn.live_dice.size} live dice. Would you like to roll again?"
          puts DecorativeLine
          puts "(R)oll ~~ (E)nd Turn ~~ (G)ame State"
          input = get_char_input.upcase
          break true if input == "R"
          break false if input == "E"
          display_game_state(game) if input == "G"
        end
      end

      def display_player_busted(player, dice)
        system('clear')
        puts "#{player.name}, you busted!!!"
        puts "Roll: #{dice.map { |die| die.value } }\n#{DecorativeLine}"
        puts "Press ENTER to switch to the next player"
        gets
      end

      def display_final_round_warning(game)
        system('clear')
        puts "WARNING: #{game.current_player.name}, this is your last turn!"
        puts "The current high score is: #{game.players.sort.reverse[0].score}"
        puts "#{DecorativeLine}\nPress ENTER to conitnue"
        gets
      end

      def display_game_results(players)
        system('clear')
        puts "Final Scores\n#{DecorativeLine}"
        players.sort.reverse.each { |p| puts "#{p.name}: #{p.score}" }
        puts DecorativeLine
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
    end
  end
end
