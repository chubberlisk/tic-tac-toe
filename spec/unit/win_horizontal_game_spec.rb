require_relative '../../lib/win_horizontal_game'
require_relative '../../lib/game'

describe WinHorizontalGame do
  class GameGatewayStub
    attr_accessor :saved_game
  end

  let(:game_gateway) { GameGatewayStub.new }
  let(:win_horizontal_game) { WinHorizontalGame.new(game_gateway) }

  context 'when Player X wins' do
    it 'can win a game when player X has 3 in a row horizontally in the first row' do 
      game_gateway.saved_game = Game.new(
        [
          [:x, :x, :x],
          [:o, :o, nil],
          [nil, nil, nil]
        ]
      )
      expect(win_horizontal_game.execute).to eq('Player X has won the game!')
    end

    it 'can win a game when player X has 3 in a row horizontally in the second row' do 
      game_gateway.saved_game = Game.new(
        [
          [:o, :o, nil],
          [:x, :x, :x],
          [nil, nil, nil]
        ]
      )
      expect(win_horizontal_game.execute).to eq('Player X has won the game!')
    end

    it 'can win a game when player X has 3 in a row horizontally in the last row' do 
      game_gateway.saved_game = Game.new(
        [
          [:o, :o, nil],
          [nil, nil, nil],
          [:x, :x, :x]
        ]
      )
      expect(win_horizontal_game.execute).to eq('Player X has won the game!')
    end
  end

  context 'when Player O wins' do
    it 'can win a game when player O has 3 in a row horizontally in the first row' do 
      game_gateway.saved_game = Game.new(
        [
          [:o, :o, :o],
          [:x, :x, nil],
          [nil, nil, nil]
        ]
      )
      expect(win_horizontal_game.execute).to eq('Player O has won the game!')
    end

    it 'can win a game when player O has 3 in a row horizontally in the second row' do 
      game_gateway.saved_game = Game.new(
        [
          [:x, :x, nil],
          [:o, :o, :o],
          [nil, nil, nil]
        ]
      )
      expect(win_horizontal_game.execute).to eq('Player O has won the game!')
    end

    it 'can win a game when player O has 3 in a row horizontally in the third row' do 
      game_gateway.saved_game = Game.new(
        [
          [:x, :x, nil],
          [nil, nil, nil],
          [:o, :o, :o]
        ]
      )
      expect(win_horizontal_game.execute).to eq('Player O has won the game!')
    end
  end

  it 'can recognise when there is no horizontal win' do
    game_gateway.saved_game = Game.new(
      [
        [:x, :o, :x],
        [:o, :o, nil],
        [nil, nil, nil]
      ]
    )
    expect(win_horizontal_game.execute).to eq('No horizontal win.')
  end
end
