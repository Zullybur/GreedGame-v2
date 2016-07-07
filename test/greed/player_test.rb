require 'lib/greed/player.rb'
require 'test/unit'

module Greed
  class PlayerTest < Test::Unit::TestCase

    def test_player_can_be_created
      player = Player.new("")
      assert_not_nil player
    end

    def test_player_name_can_only_be_set_when_created
      player = Player.new("Test")
      assert_equal "Test", player.name
      assert_raise(NoMethodError) do
        player.name = "Error"
      end
    end

    def test_player_score_is_read_write
      player = Player.new("Test")
      assert_equal 0, player.score
      player.score = 10
      assert_equal 10, player.score
    end

    def test_player_number_is_read_only
      player = Player.new("Test")
      assert_equal 8, player.number
      assert_raise(NoMethodError) do
        player.number = 2
      end
    end

    def test_player_number_and_object_count_increment
      players = []
      5.times do
        players << Player.new("Test")
      end
      players.each.with_index(3) do |player, i|
        assert_equal i, player.number
      end
      assert_equal 7, Player.count
    end
  end
end
