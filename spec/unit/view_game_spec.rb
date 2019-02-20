require_relative '../../lib/view_game'
require_relative '../../lib/game'

describe ViewGame do
  class GameGatewayStub
    attr_accessor :saved_game
  end

  it 'can view a game' do
    game_gateway = GameGatewayStub.new
    view_game = ViewGame.new(game_gateway)

    game_gateway.saved_game = Game.new(
      [
        [nil, nil, nil],
        [nil, nil, nil],
        [nil, nil, nil]
      ]
    )

    expect(view_game.execute.grid).to eq(
      [
        [nil, nil, nil],
        [nil, nil, nil],
        [nil, nil, nil]
      ]
    )
  end
end
