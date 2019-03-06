require_relative '../test_doubles/grid_gateway_stub'
require_relative '../../lib/evaluate_grid'
require_relative '../../lib/grid'

describe EvaluateGrid do
  let(:grid_gateway) { GridGatewayStub.new }
  let(:evaluate_grid) { EvaluateGrid.new(grid_gateway) }
  let(:grid) { Grid.new }

  context 'when Player X wins horizontally' do
    it 'can win a game when player X has 3 in a row horizontally in the first row' do 
      grid.state = [
        [:x, :x, :x],
        [:o, :o, nil],
        [nil, nil, nil]
      ]

      grid_gateway.saved_grid = grid

      expect(evaluate_grid.execute).to eq(:player_x_win)
    end

    it 'can win a game when player X has 3 in a row horizontally in the second row' do 
      grid.state = [
        [:o, :o, nil],
        [:x, :x, :x],
        [nil, nil, nil]
      ]

      grid_gateway.saved_grid = grid

      expect(evaluate_grid.execute).to eq(:player_x_win)
    end

    it 'can win a game when player X has 3 in a row horizontally in the last row' do
      grid.state = [
        [:o, :o, nil],
        [nil, nil, nil],
        [:x, :x, :x]
      ]

      grid_gateway.saved_grid = grid

      expect(evaluate_grid.execute).to eq(:player_x_win)
    end
  end

  context 'when Player O wins horizontally' do
    it 'can win a game when player O has 3 in a row horizontally in the first row' do 
      grid.state = [
        [:o, :o, :o],
        [:x, :x, nil],
        [nil, nil, nil]
      ]

      grid_gateway.saved_grid = grid

      expect(evaluate_grid.execute).to eq(:player_o_win)
    end

    it 'can win a game when player O has 3 in a row horizontally in the second row' do 
      grid.state = [
        [:x, :x, nil],
        [:o, :o, :o],
        [nil, nil, nil]
      ]

      grid_gateway.saved_grid = grid

      expect(evaluate_grid.execute).to eq(:player_o_win)
    end

    it 'can win a game when player O has 3 in a row horizontally in the third row' do 
      grid.state = [
        [:x, :x, nil],
        [nil, nil, nil],
        [:o, :o, :o]
      ]

      grid_gateway.saved_grid = grid

      expect(evaluate_grid.execute).to eq(:player_o_win)
    end
  end

  context 'when Player X wins vertically' do
    it 'can win a game when player X has 3 in a column vertically in the first column' do 
      grid.state = [
        [:x, :o, :o],
        [:x, nil, nil],
        [:x, nil, nil]
      ]

      grid_gateway.saved_grid = grid

      expect(evaluate_grid.execute).to eq(:player_x_win)
    end

    it 'can win a game when player X has 3 in a column vertically in the second column' do 
      grid.state = [
        [nil, :x, nil],
        [nil, :x, :o],
        [:o, :x, nil]
      ]

      grid_gateway.saved_grid = grid

      expect(evaluate_grid.execute).to eq(:player_x_win)
    end

    it 'can win a game when player X has 3 in a column vertically in the last column' do 
      grid.state = [
        [nil, nil, :x],
        [:o, nil, :x],
        [:o, nil, :x]
      ]

      grid_gateway.saved_grid = grid
      
      expect(evaluate_grid.execute).to eq(:player_x_win)
    end
  end

  context 'when Player O wins vertically' do
    it 'can win a game when player O has 3 in a column vertically in the first column' do 
      grid.state = [
        [:o, nil, nil],
        [:o, :x, nil],
        [:o, nil, :x]
      ]

      grid_gateway.saved_grid = grid

      expect(evaluate_grid.execute).to eq(:player_o_win)
    end

    it 'can win a game when player O has 3 in a column vertically in the second column' do 
      grid.state = [
        [:x, :o, nil],
        [nil, :o, :x],
        [nil, :o, nil]
      ]

      grid_gateway.saved_grid = grid

      expect(evaluate_grid.execute).to eq(:player_o_win)
    end

    it 'can win a game when player O has 3 in a column vertically in the third column' do 
      grid.state = [
        [nil, :x, :o],
        [:x, nil, :o],
        [nil, nil, :o]
      ]

      grid_gateway.saved_grid = grid

      expect(evaluate_grid.execute).to eq(:player_o_win)
    end
  end

  context 'when Player X wins diagonally' do
    it 'can win a game when player X has 3 in a row diagonally from bottom left to top right' do 
      grid.state = [
        [:o, nil, :x],
        [nil, :x, nil],
        [:x, nil, :o]
      ]

      grid_gateway.saved_grid = grid

      expect(evaluate_grid.execute).to eq(:player_x_win)
    end

    it 'can win a game when player X has 3 in a row diagonally from top left to bottom right' do 
      grid.state = [
        [:x, nil, nil],
        [nil, :x, :o],
        [:o, nil, :x]
      ]

      grid_gateway.saved_grid = grid

      expect(evaluate_grid.execute).to eq(:player_x_win)
    end
  end

  context 'when Player O wins diagonally' do
    it 'can win a game when player o has 3 in a row diagonally from bottom left to top right' do 
      grid.state = [
        [:x, nil, :o],
        [nil, :o, :x],
        [:o, nil, nil]
      ]

      grid_gateway.saved_grid = grid

      expect(evaluate_grid.execute).to eq(:player_o_win)
    end

    it 'can win a game when player O has 3 in a row diagonally from top left to bottom right' do 
      grid.state = [
        [:o, nil, :x],
        [:x, :o, nil],
        [nil, nil, :o]
      ]

      grid_gateway.saved_grid = grid

      expect(evaluate_grid.execute).to eq(:player_o_win)
    end

    it 'can win a game on the games last turn' do
      grid.state = [
        [:o, :o, :x],
        [:x, :o, :o],
        [:x, :o, :x]
      ]

      grid_gateway.saved_grid = grid

      expect(evaluate_grid.execute).to eq(:player_o_win)
    end
  end

  context 'when there is not a winner' do
    it 'can recognise when there is no horizontal win' do
      grid.state = [
        [:x, :o, :x],
        [:o, :o, nil],
        [nil, nil, nil]
      ]

      grid_gateway.saved_grid = grid

      expect(evaluate_grid.execute).to eq(:no_win)
    end

    it 'can recognise when there is no vertical win' do
      grid.state = [
        [:x, :o, nil],
        [nil, nil, :x],
        [nil, :o, nil]
      ]

      grid_gateway.saved_grid = grid

      expect(evaluate_grid.execute).to eq(:no_win)
    end
  end

  context 'when there is a draw' do
    it 'can draw a game' do
      grid.state = [
        [:x, :x, :o],
        [:o, :o, :x],
        [:x, :o, :x]
      ]

      grid_gateway.saved_grid = grid

      expect(evaluate_grid.execute).to eq(:draw)
    end

    it 'can draw a game for a different grid' do
      grid.state = [
        [:x, :o, :o],
        [:o, :x, :x],
        [:o, :x, :o]
      ]

      grid_gateway.saved_grid = grid

      expect(evaluate_grid.execute).to eq(:draw)
    end
  end
end
