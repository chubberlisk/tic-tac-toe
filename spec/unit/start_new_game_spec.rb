require_relative '../../lib/start_new_game'

describe StartNewGame do
  class GameGatewaySpy
    attr_reader :saved_game

    def save(game)
      @saved_game = game
    end
  end

  it 'saves a game' do
    game_gateway = GameGatewaySpy.new
    start_new_game = StartNewGame.new(game_gateway)

    start_new_game.execute

    expect(game_gateway.saved_game.grid).to eq(
      [
        [nil, nil, nil],
        [nil, nil, nil],
        [nil, nil, nil]
      ]
    )
  end
end
