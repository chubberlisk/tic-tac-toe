# frozen_string_literal: true

class GameGatewayFake
  attr_accessor :saved_game

  def retrieve
    @saved_game.dup
  end

  def save(game)
    @saved_game = game
  end
end
