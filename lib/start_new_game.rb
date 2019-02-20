require 'game'

class StartNewGame
  def initialize(game_gateway)
    @game_gateway = game_gateway
  end

  def execute
    @game_gateway.save(
      Game.new([
        [nil, nil, nil],
        [nil, nil, nil],
        [nil, nil, nil]
      ])
    )
  end
end
