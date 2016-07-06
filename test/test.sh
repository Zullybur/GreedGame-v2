ruby -I . -I lib test/greed/die_test.rb
printf "\n~~Player Tests~~\n"
ruby -I . -I lib test/greed/player_test.rb
printf "\n~~Roll Tests~~\n"
ruby -I . -I lib test/greed/roll_test.rb
printf "\n~~RollScore Tests~~\n"
ruby -I . -I lib test/greed/roll_score_test.rb
#printf "\n~~Turn Tests~~\n"
#ruby -I . -I lib test/greed/turn_test.rb
