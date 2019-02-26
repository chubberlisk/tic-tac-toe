require_relative '../../lib/win_vertical_game'
require_relative '../../lib/game'

describe WinVerticalGame do
  class GameGatewayStub
    attr_accessor :saved_game
  end

  let(:game_gateway) { GameGatewayStub.new }
  let(:win_vertical_game) { WinVerticalGame.new(game_gateway) }

  context 'when Player X wins' do
    it 'can win a game when player X has 3 in a column vertically in the first column' do 
      game_gateway.saved_game = Game.new(
        [
          [:x, :o, :o],
          [:x, nil, nil],
          [:x, nil, nil]
        ]
      )
      expect(win_vertical_game.execute).to eq(:player_x_win)
    end

    it 'can win a game when player X has 3 in a column vertically in the second column' do 
      game_gateway.saved_game = Game.new(
        [
          [nil, :x, nil],
          [nil, :x, :o],
          [:o, :x, nil]
        ]
      )
      expect(win_vertical_game.execute).to eq(:player_x_win)
    end

    it 'can win a game when player X has 3 in a column vertically in the last column' do 
      game_gateway.saved_game = Game.new(
        [
          [nil, nil, :x],
          [:o, nil, :x],
          [:o, nil, :x]
        ]
      )
      expect(win_vertical_game.execute).to eq(:player_x_win)
    end
  end

  context 'when Player O wins' do
    it 'can win a game when player O has 3 in a column vertically in the first column' do 
      game_gateway.saved_game = Game.new(
        [
          [:o, nil, nil],
          [:o, :x, nil],
          [:o, nil, :x]
        ]
      )
      expect(win_vertical_game.execute).to eq(:player_o_win)
    end

    it 'can win a game when player O has 3 in a column vertically in the second column' do 
      game_gateway.saved_game = Game.new(
        [
          [:x, :o, nil],
          [nil, :o, :x],
          [nil, :o, nil]
        ]
      )
      expect(win_vertical_game.execute).to eq(:player_o_win)
    end

    it 'can win a game when player O has 3 in a column vertically in the third column' do 
      game_gateway.saved_game = Game.new(
        [
          [nil, :x, :o],
          [:x, nil, :o],
          [nil, nil, :o]
        ]
      )
      expect(win_vertical_game.execute).to eq(:player_o_win)
    end
  end

  it 'can recognise when there is no vertical win' do
    game_gateway.saved_game = Game.new(
      [
        [:x, :o, nil],
        [nil, nil, :x],
        [nil, :o, nil]
      ]
    )
    expect(win_vertical_game.execute).to eq(:no_win)
  end
end
