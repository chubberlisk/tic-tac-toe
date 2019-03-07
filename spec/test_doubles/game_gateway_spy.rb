class GameGatewaySpy
  attr_reader :saved_game

  def save(game)
    @saved_game = game
  end
end
