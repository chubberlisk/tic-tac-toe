require_relative '../../lib/win_horizontal_game'
require_relative '../../lib/game'

describe WinHorizontalGame do\

  class GameGatewayStub
    attr_writer :saved_game
  end

  it 'can win a game when player X has 3 in a row horizontally in the first row' do 
    game_gateway = GameGatewayStub.new
    win_horizontal_game = WinHorizontalGame.new(game_gateway)
    game_gateway.saved_game = Game.new(
      [
        [:x, :x, :x],
        [:o, :o, nil],
        [nil, nil, nil]
      ]
    )
    expect(win_horizontal_game.execute).to eq('Player X has won the game!')
  end

end
