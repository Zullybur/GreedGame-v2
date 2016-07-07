require 'greed/turn'
require 'pry'

module Greed
  @state = "main_menu"
  DecorativeLine =  "~~~~~~~~~~~~~~~~~"

  class << self
    def display_main_menu_get_response
      @state = loop do
                 system('clear')
                 puts "Welcome to Greed!\n#{DecorativeLine}"
                 puts "(R)ules (P)lay"
                 input = get_char_input.upcase
                 break "rules" if input == "R"
                 break "new_game" if input == "P"
               end
    end

    def get_char_input
      gets(1).chomp
    end

    def display_rules
      system('clear')
      system('cat GREED_RULES.txt | more')
      puts "#{DecorativeLine}\n(M)ain Menu"
      loop do
        break if get_char_input.upcase == "M"
      end
      @state = "main_menu"
    end
  end

  while true
    case @state
    when "main_menu" then display_main_menu_get_response
    when "rules" then display_rules
    when "new_game"
      puts "TODO: game driver"
    else 
      puts "Sanity check failed - illegal state"
      break
    end
  end
end
