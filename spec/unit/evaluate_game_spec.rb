require_relative '../test_doubles/game_gateway_stub'
require_relative '../../lib/evaluate_game'
require_relative '../../lib/game'

describe EvaluateGame do
  let(:game_gateway) { GameGatewayStub.new }
  let(:evaluate_game) { EvaluateGame.new(game_gateway) }

  context 'when Player X wins horizontally' do
    it 'can win a game when player X has 3 in a row horizontally in the first row' do 
      game_gateway.saved_game = Game.new(
        [
          [:x, :x, :x],
          [:o, :o, nil],
          [nil, nil, nil]
        ]
      )
      expect(evaluate_game.execute).to eq(:player_x_win)
    end

    it 'can win a game when player X has 3 in a row horizontally in the second row' do 
      game_gateway.saved_game = Game.new(
        [
          [:o, :o, nil],
          [:x, :x, :x],
          [nil, nil, nil]
        ]
      )
      expect(evaluate_game.execute).to eq(:player_x_win)
    end

    it 'can win a game when player X has 3 in a row horizontally in the last row' do 
      game_gateway.saved_game = Game.new(
        [
          [:o, :o, nil],
          [nil, nil, nil],
          [:x, :x, :x]
        ]
      )
      expect(evaluate_game.execute).to eq(:player_x_win)
    end
  end

  context 'when Player O wins horizontally' do
    it 'can win a game when player O has 3 in a row horizontally in the first row' do 
      game_gateway.saved_game = Game.new(
        [
          [:o, :o, :o],
          [:x, :x, nil],
          [nil, nil, nil]
        ]
      )
      expect(evaluate_game.execute).to eq(:player_o_win)
    end

    it 'can win a game when player O has 3 in a row horizontally in the second row' do 
      game_gateway.saved_game = Game.new(
        [
          [:x, :x, nil],
          [:o, :o, :o],
          [nil, nil, nil]
        ]
      )
      expect(evaluate_game.execute).to eq(:player_o_win)
    end

    it 'can win a game when player O has 3 in a row horizontally in the third row' do 
      game_gateway.saved_game = Game.new(
        [
          [:x, :x, nil],
          [nil, nil, nil],
          [:o, :o, :o]
        ]
      )
      expect(evaluate_game.execute).to eq(:player_o_win)
    end
  end

  context 'when Player X wins vertically' do
    it 'can win a game when player X has 3 in a column vertically in the first column' do 
      game_gateway.saved_game = Game.new(
        [
          [:x, :o, :o],
          [:x, nil, nil],
          [:x, nil, nil]
        ]
      )
      expect(evaluate_game.execute).to eq(:player_x_win)
    end

    it 'can win a game when player X has 3 in a column vertically in the second column' do 
      game_gateway.saved_game = Game.new(
        [
          [nil, :x, nil],
          [nil, :x, :o],
          [:o, :x, nil]
        ]
      )
      expect(evaluate_game.execute).to eq(:player_x_win)
    end

    it 'can win a game when player X has 3 in a column vertically in the last column' do 
      game_gateway.saved_game = Game.new(
        [
          [nil, nil, :x],
          [:o, nil, :x],
          [:o, nil, :x]
        ]
      )
      expect(evaluate_game.execute).to eq(:player_x_win)
    end
  end

  context 'when Player O wins vertically' do
    it 'can win a game when player O has 3 in a column vertically in the first column' do 
      game_gateway.saved_game = Game.new(
        [
          [:o, nil, nil],
          [:o, :x, nil],
          [:o, nil, :x]
        ]
      )
      expect(evaluate_game.execute).to eq(:player_o_win)
    end

    it 'can win a game when player O has 3 in a column vertically in the second column' do 
      game_gateway.saved_game = Game.new(
        [
          [:x, :o, nil],
          [nil, :o, :x],
          [nil, :o, nil]
        ]
      )
      expect(evaluate_game.execute).to eq(:player_o_win)
    end

    it 'can win a game when player O has 3 in a column vertically in the third column' do 
      game_gateway.saved_game = Game.new(
        [
          [nil, :x, :o],
          [:x, nil, :o],
          [nil, nil, :o]
        ]
      )
      expect(evaluate_game.execute).to eq(:player_o_win)
    end
  end

  context 'when there is not a winner' do
    it 'can recognise when there is no horizontal win' do
      game_gateway.saved_game = Game.new(
        [
          [:x, :o, :x],
          [:o, :o, nil],
          [nil, nil, nil]
        ]
      )
      expect(evaluate_game.execute).to eq(:no_win)
    end

    it 'can recognise when there is no vertical win' do
      game_gateway.saved_game = Game.new(
        [
          [:x, :o, nil],
          [nil, nil, :x],
          [nil, :o, nil]
        ]
      )
      expect(evaluate_game.execute).to eq(:no_win)
    end
  end
end
