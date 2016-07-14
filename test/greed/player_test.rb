require 'lib/greed/player.rb'
require 'test/unit'

module Greed
  class PlayerTest < Test::Unit::TestCase

    def test_player_can_be_created
      assert_not_nil Player.new("Matt")
    end

    def test_player_name_is_set_properly
      assert_equal "test", Player.new("test").name
    end

    def test_player_name_can_only_be_set_through_constructor
      player = Player.new("test")
      assert_raise(NoMethodError) { player.name = "Error" }
    end

    def test_player_score_is_read_write
      player = Player.new("Test")
      assert_equal 0, player.score
      assert_nothing_raised { player.score = 10 }
      assert_equal 10, player.score
    end

    def test_player_number_is_read_only
      Player.class_eval('@@count = 0')
      player = Player.new("Test")
      assert_equal 1, player.number
      assert_raise(NoMethodError) { player.number = 2 }
    end

    def test_player_number_and_object_count_increment
      Player.class_eval('@@count = 0')
      players = []
      5.times do
        players << Player.new("Test")
      end
      players.each.with_index(1) do |player, i|
        assert_equal i, player.number
      end
      assert_equal 5, Player.count
    end
  end
end
