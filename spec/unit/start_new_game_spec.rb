require_relative '../test_doubles/game_gateway_spy'
require_relative '../../lib/start_new_game'

describe StartNewGame do
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
