# frozen_string_literal: true
require_relative '../test_doubles/game_gateway_fake'
require_relative '../../lib/start_new_game'
require_relative '../../lib/view_game'
require_relative '../../lib/place_marker'
require_relative '../../lib/evaluate_game'

describe 'Tic Tac Toe' do
  let(:game_gateway) { GameGatewayFake.new }
  let(:start_new_game) { StartNewGame.new(game_gateway) }
  let(:view_game) { ViewGame.new(game_gateway) }
  let(:place_marker) { PlaceMarker.new(game_gateway) }
  let(:empty_grid) do
    [
      [nil, nil, nil],
      [nil, nil, nil],
      [nil, nil, nil]
    ]
  end

  it 'can start and view a new game' do
    start_new_game.execute

    expect(view_game.execute.grid).to eq(empty_grid)
  end

  context 'when game has started' do
    before { game_gateway.saved_game = Game.new(empty_grid) }

    it 'can place an X marker in a position on the grid' do
      place_marker.execute(:x, [0, 0])

      expect(view_game.execute.grid).to eq(
        [
          [:x, nil, nil],
          [nil, nil, nil],
          [nil, nil, nil]
        ]
      )
    end

    it 'can place an O marker in a position on the grid' do
      place_marker.execute(:o, [2, 2])

      expect(view_game.execute.grid).to eq(
        [
          [nil, nil, nil],
          [nil, nil, nil],
          [nil, nil, :o]
        ]
      )
    end

    it 'can place an X and O marker in a position on the grid' do
      place_marker.execute(:x, [0, 2])
      place_marker.execute(:o, [1, 1])

      expect(view_game.execute.grid).to eq(
        [
          [nil, nil, :x],
          [nil, :o, nil],
          [nil, nil, nil]
        ]
      )
    end

    it 'cannot place a marker in a position that already has a marker' do
      place_marker.execute(:x, [2, 1])

      expect(view_game.execute.grid).to eq(
        [
          [nil, nil, nil],
          [nil, nil, nil],
          [nil, :x, nil]
        ]
      )

      expect { place_marker.execute(:o, [2, 1]) }.to raise_error(PlaceMarker::InvalidMoveError)
      expect(view_game.execute.grid).to eq(
        [
          [nil, nil, nil],
          [nil, nil, nil],
          [nil, :x, nil]
        ]
      )
    end

    it 'cannot place a marker in a position that is outside the grid' do
      expect { place_marker.execute(:o, [-6, 1]) }.to raise_error(PlaceMarker::InvalidPositionError)
      expect(view_game.execute.grid).to eq(empty_grid)

      expect { place_marker.execute(:o, [3, 0]) }.to raise_error(PlaceMarker::InvalidPositionError)
      expect(view_game.execute.grid).to eq(empty_grid)

      expect { place_marker.execute(:o, [2, -3]) }.to raise_error(PlaceMarker::InvalidPositionError)
      expect(view_game.execute.grid).to eq(empty_grid)

      expect { place_marker.execute(:o, [2, 7]) }.to raise_error(PlaceMarker::InvalidPositionError)
      expect(view_game.execute.grid).to eq(empty_grid)
    end
  end

  context 'when a player wins horizontally' do
    let(:evaluate_game) { EvaluateGame.new(game_gateway) }

    before { game_gateway.saved_game = Game.new(empty_grid) }

    it 'can win a game when player X has 3 in a row horizontally in the first row' do
      place_marker.execute(:x, [0, 0])
      place_marker.execute(:o, [1, 0])
      place_marker.execute(:x, [0, 1])
      place_marker.execute(:o, [1, 1])
      place_marker.execute(:x, [0, 2])

      expect(view_game.execute.grid).to eq(
        [
          [:x, :x, :x],
          [:o, :o, nil],
          [nil, nil, nil]
        ]
      )
      expect(evaluate_game.execute).to eq(:player_x_win)
    end

    it 'can win a game when player X has 3 in a row horizontally in the second row' do
      place_marker.execute(:x, [1, 0])
      place_marker.execute(:o, [0, 0])
      place_marker.execute(:x, [1, 1])
      place_marker.execute(:o, [0, 1])
      place_marker.execute(:x, [1, 2])

      expect(view_game.execute.grid).to eq(
        [
          [:o, :o, nil],
          [:x, :x, :x],
          [nil, nil, nil]
        ]
      )
      expect(evaluate_game.execute).to eq(:player_x_win)
    end

    it 'can win a game when player X has 3 in a row horizontally in the third row' do
      place_marker.execute(:x, [2, 0])
      place_marker.execute(:o, [0, 0])
      place_marker.execute(:x, [2, 1])
      place_marker.execute(:o, [0, 1])
      place_marker.execute(:x, [2, 2])

      expect(view_game.execute.grid).to eq(
        [
          [:o, :o, nil],
          [nil, nil, nil],
          [:x, :x, :x]
        ]
      )
      expect(evaluate_game.execute).to eq(:player_x_win)
    end

    it 'can win a game when player O has 3 in a row horizontally in the first row' do
      place_marker.execute(:o, [0, 0])
      place_marker.execute(:x, [1, 0])
      place_marker.execute(:o, [0, 1])
      place_marker.execute(:x, [1, 1])
      place_marker.execute(:o, [0, 2])

      expect(view_game.execute.grid).to eq(
        [
          [:o, :o, :o],
          [:x, :x, nil],
          [nil, nil, nil]
        ]
      )
      expect(evaluate_game.execute).to eq(:player_o_win)
    end

    it 'can win a game when player O has 3 in a row horizontally in the second row' do
      place_marker.execute(:x, [1, 0])
      place_marker.execute(:o, [0, 0])
      place_marker.execute(:x, [1, 1])
      place_marker.execute(:o, [0, 1])
      place_marker.execute(:x, [1, 2])

      expect(view_game.execute.grid).to eq(
        [
          [:o, :o, nil],
          [:x, :x, :x],
          [nil, nil, nil]
        ]
      )
      expect(evaluate_game.execute).to eq(:player_x_win)
    end

    it 'can win a game when player O has 3 in a row horizontally in the third row' do
      place_marker.execute(:x, [2, 0])
      place_marker.execute(:o, [0, 0])
      place_marker.execute(:x, [2, 1])
      place_marker.execute(:o, [0, 1])
      place_marker.execute(:x, [2, 2])

      expect(view_game.execute.grid).to eq(
        [
          [:o, :o, nil],
          [nil, nil, nil],
          [:x, :x, :x]
        ]
      )
      expect(evaluate_game.execute).to eq(:player_x_win)
    end

    it 'can recognise when there is no horizontal win' do
      place_marker.execute(:o, [0, 0])
      place_marker.execute(:x, [2, 1])
      place_marker.execute(:o, [0, 1])
      place_marker.execute(:x, [2, 2])

      expect(view_game.execute.grid).to eq(
        [
          [:o, :o, nil],
          [nil, nil, nil],
          [nil, :x, :x]
        ]
      )

      expect(evaluate_game.execute).to eq(:no_win)
    end
  end

  context 'when a player wins vertically' do
    let(:evaluate_game) { EvaluateGame.new(game_gateway) }

    before { game_gateway.saved_game = Game.new(empty_grid) }

    it 'can win a game when player X has 3 in a row vertically in the first column' do
      place_marker.execute(:x, [0, 0])
      place_marker.execute(:o, [0, 1])
      place_marker.execute(:x, [1, 0])
      place_marker.execute(:o, [0, 2])
      place_marker.execute(:x, [2, 0])

      expect(view_game.execute.grid).to eq(
        [
          [:x, :o, :o],
          [:x, nil, nil],
          [:x, nil, nil]
        ]
      )
      expect(evaluate_game.execute).to eq(:player_x_win)
    end

    it 'can win a game when player X has 3 in a row vertically in the second column' do
      place_marker.execute(:x, [0, 1])
      place_marker.execute(:o, [1, 0])
      place_marker.execute(:x, [1, 1])
      place_marker.execute(:o, [2, 0])
      place_marker.execute(:x, [2, 1])

      expect(view_game.execute.grid).to eq(
        [
          [nil, :x, nil],
          [:o, :x, nil],
          [:o, :x, nil]
        ]
      )
      expect(evaluate_game.execute).to eq(:player_x_win)
    end

    it 'can win a game when player X has 3 in a row vertically in the third column' do
      place_marker.execute(:x, [0, 2])
      place_marker.execute(:o, [0, 1])
      place_marker.execute(:x, [1, 2])
      place_marker.execute(:o, [2, 0])
      place_marker.execute(:x, [2, 2])

      expect(view_game.execute.grid).to eq(
        [
          [nil, :o, :x],
          [nil, nil, :x],
          [:o, nil, :x]
        ]
      )
      expect(evaluate_game.execute).to eq(:player_x_win)
    end

    it 'can win a game when player O has 3 in a row horizontally in the first column' do
      place_marker.execute(:o, [0, 0])
      place_marker.execute(:x, [0, 1])
      place_marker.execute(:o, [1, 0])
      place_marker.execute(:x, [2, 1])
      place_marker.execute(:o, [2, 0])

      expect(view_game.execute.grid).to eq(
        [
          [:o, :x, nil],
          [:o, nil, nil],
          [:o, :x, nil]
        ]
      )
      expect(evaluate_game.execute).to eq(:player_o_win)
    end

    it 'can win a game when player O has 3 in a row vertically in the second column' do
      place_marker.execute(:o, [0, 1])
      place_marker.execute(:x, [1, 0])
      place_marker.execute(:o, [1, 1])
      place_marker.execute(:x, [1, 2])
      place_marker.execute(:o, [2, 1])

      expect(view_game.execute.grid).to eq(
        [
          [nil, :o, nil],
          [:x, :o, :x],
          [nil, :o, nil]
        ]
      )
      expect(evaluate_game.execute).to eq(:player_o_win)
    end

    it 'can win a game when player O has 3 in a row vertically in the third column' do
      place_marker.execute(:o, [0, 2])
      place_marker.execute(:x, [0, 1])
      place_marker.execute(:o, [1, 2])
      place_marker.execute(:x, [2, 0])
      place_marker.execute(:o, [2, 2])

      expect(view_game.execute.grid).to eq(
        [
          [nil, :x, :o],
          [nil, nil, :o],
          [:x, nil, :o]
        ]
      )
      expect(evaluate_game.execute).to eq(:player_o_win)
    end

    it 'can recognise when there is no vertical win' do
      place_marker.execute(:o, [0, 0])
      place_marker.execute(:x, [0, 1])
      place_marker.execute(:o, [1, 2])
      place_marker.execute(:x, [2, 1])

      expect(view_game.execute.grid).to eq(
        [
          [:o, :x, nil],
          [nil, nil, :o],
          [nil, :x, nil]
        ]
      )

      expect(evaluate_game.execute).to eq(:no_win)
    end
  end

  context 'when a player wins diagonally' do
    let(:evaluate_game) { EvaluateGame.new(game_gateway) }

    before { game_gateway.saved_game = Game.new(empty_grid) }

    it 'can win a game when player X has 3 in a row diagonally from bottom left to top right' do
      place_marker.execute(:x, [2, 0])
      place_marker.execute(:o, [0, 0])
      place_marker.execute(:x, [1, 1])
      place_marker.execute(:o, [1, 2])
      place_marker.execute(:x, [0, 2])

      expect(view_game.execute.grid).to eq(
        [
          [:o, nil, :x],
          [nil, :x, :o],
          [:x, nil, nil]
        ]
      )
      expect(evaluate_game.execute).to eq(:player_x_win)
    end

    it 'can win a game when player X has 3 in a row diagonally from top left to bottom right' do
      place_marker.execute(:x, [0, 0])
      place_marker.execute(:o, [1, 0])
      place_marker.execute(:x, [1, 1])
      place_marker.execute(:o, [2, 0])
      place_marker.execute(:x, [2, 2])

      expect(view_game.execute.grid).to eq(
        [
          [:x, nil, nil],
          [:o, :x, nil],
          [:o, nil, :x]
        ]
      )
      expect(evaluate_game.execute).to eq(:player_x_win)
    end

    it 'can win a game when player O has 3 in a row diagonally from bottom left to top right' do
      place_marker.execute(:o, [2, 0])
      place_marker.execute(:x, [0, 0])
      place_marker.execute(:o, [1, 1])
      place_marker.execute(:x, [1, 2])
      place_marker.execute(:o, [0, 2])

      expect(view_game.execute.grid).to eq(
        [
          [:x, nil, :o],
          [nil, :o, :x],
          [:o, nil, nil]
        ]
      )
      expect(evaluate_game.execute).to eq(:player_o_win)
    end

    it 'can win a game when player O has 3 in a row diagonally from top left to bottom right' do
      place_marker.execute(:o, [0, 0])
      place_marker.execute(:x, [1, 0])
      place_marker.execute(:o, [1, 1])
      place_marker.execute(:x, [0, 2])
      place_marker.execute(:o, [2, 2])

      expect(view_game.execute.grid).to eq(
        [
          [:o, nil, :x],
          [:x, :o, nil],
          [nil, nil, :o]
        ]
      )
      expect(evaluate_game.execute).to eq(:player_o_win)
    end
  end
end
