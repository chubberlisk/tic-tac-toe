class GameGatewayFake
  attr_accessor :saved_game

  def save(game)
    @saved_game = game
  end
end
