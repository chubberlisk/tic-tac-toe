# frozen_string_literal: true
require_relative '../../lib/start_new_game'
require_relative '../../lib/view_game'
require_relative '../../lib/place_marker'
require_relative '../../lib/win_horizontal_game'

describe 'Tic Tac Toe' do
  class InMemoryGameGateway
    attr_accessor :saved_game

    def save(game)
      @saved_game = game
    end
  end

  let(:game_gateway) { InMemoryGameGateway.new }
  let(:start_new_game) { StartNewGame.new(game_gateway) }
  let(:view_game) { ViewGame.new(game_gateway) }
  let(:place_x_marker) { PlaceMarker.new(game_gateway) }
  let(:place_o_marker) { PlaceMarker.new(game_gateway) }
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
      place_x_marker.execute(:x, [0, 0])

      expect(view_game.execute.grid).to eq(
        [
          [:x, nil, nil],
          [nil, nil, nil],
          [nil, nil, nil]
        ]
      )
    end

    it 'can place an O marker in a position on the grid' do
      place_o_marker.execute(:o, [2, 2])

      expect(view_game.execute.grid).to eq(
        [
          [nil, nil, nil],
          [nil, nil, nil],
          [nil, nil, :o]
        ]
      )
    end

    it 'can place an X and O marker in a position on the grid' do
      place_x_marker.execute(:x, [0, 2])
      place_o_marker.execute(:o, [1, 1])

      expect(view_game.execute.grid).to eq(
        [
          [nil, nil, :x],
          [nil, :o, nil],
          [nil, nil, nil]
        ]
      )
    end

    it 'cannot place a marker in a position that already has a marker' do
      place_x_marker.execute(:x, [2, 1])

      expect(view_game.execute.grid).to eq(
        [
          [nil, nil, nil],
          [nil, nil, nil],
          [nil, :x, nil]
        ]
      )

      expect { place_o_marker.execute(:o, [2, 1]) }.to raise_error(PlaceMarker::InvalidMoveError)
      expect(view_game.execute.grid).to eq(
        [
          [nil, nil, nil],
          [nil, nil, nil],
          [nil, :x, nil]
        ]
      )
    end
  end

  context 'when a player wins horizontally' do
    let(:win_horizontal_game) { WinHorizontalGame.new(game_gateway) }

    before { game_gateway.saved_game = Game.new(empty_grid) }


    it 'can win a game when player X has 3 in a row horizontally in the first row' do
      place_x_marker.execute(:x, [0, 0])
      place_o_marker.execute(:o, [1, 0])
      place_x_marker.execute(:x, [0, 1])
      place_o_marker.execute(:o, [1, 1])
      place_x_marker.execute(:x, [0, 2])

      expect(view_game.execute.grid).to eq(
        [
          [:x, :x, :x],
          [:o, :o, nil],
          [nil, nil, nil]
        ]
      )
      expect(win_horizontal_game.execute).to eq('Player X has won the game!')
    end

    it 'can win a game when player X has 3 in a row horizontally in the second row' do
      place_x_marker.execute(:x, [1, 0])
      place_o_marker.execute(:o, [0, 0])
      place_x_marker.execute(:x, [1, 1])
      place_o_marker.execute(:o, [0, 1])
      place_x_marker.execute(:x, [1, 2])

      expect(view_game.execute.grid).to eq(
        [
          [:o, :o, nil],
          [:x, :x, :x],
          [nil, nil, nil]
        ]
      )
      expect(win_horizontal_game.execute).to eq('Player X has won the game!')
    end

    it 'can win a game when player X has 3 in a row horizontally in the third row' do
      place_x_marker.execute(:x, [2, 0])
      place_o_marker.execute(:o, [0, 0])
      place_x_marker.execute(:x, [2, 1])
      place_o_marker.execute(:o, [0, 1])
      place_x_marker.execute(:x, [2, 2])

      expect(view_game.execute.grid).to eq(
        [
          [:o, :o, nil],
          [nil, nil, nil],
          [:x, :x, :x]
        ]
      )
      expect(win_horizontal_game.execute).to eq('Player X has won the game!')
    end

    it 'can win a game when player O has 3 in a row horizontally in the first row' do
      place_x_marker.execute(:o, [0, 0])
      place_o_marker.execute(:x, [1, 0])
      place_x_marker.execute(:o, [0, 1])
      place_o_marker.execute(:x, [1, 1])
      place_x_marker.execute(:o, [0, 2])

      expect(view_game.execute.grid).to eq(
        [
          [:o, :o, :o],
          [:x, :x, nil],
          [nil, nil, nil]
        ]
      )
      expect(win_horizontal_game.execute).to eq('Player O has won the game!')
    end

    it 'can win a game when player O has 3 in a row horizontally in the second row' do
      place_x_marker.execute(:x, [1, 0])
      place_o_marker.execute(:o, [0, 0])
      place_x_marker.execute(:x, [1, 1])
      place_o_marker.execute(:o, [0, 1])
      place_x_marker.execute(:x, [1, 2])

      expect(view_game.execute.grid).to eq(
        [
          [:o, :o, nil],
          [:x, :x, :x],
          [nil, nil, nil]
        ]
      )
      expect(win_horizontal_game.execute).to eq('Player X has won the game!')
    end

    it 'can win a game when player O has 3 in a row horizontally in the third row' do
      place_x_marker.execute(:x, [2, 0])
      place_o_marker.execute(:o, [0, 0])
      place_x_marker.execute(:x, [2, 1])
      place_o_marker.execute(:o, [0, 1])
      place_x_marker.execute(:x, [2, 2])

      expect(view_game.execute.grid).to eq(
        [
          [:o, :o, nil],
          [nil, nil, nil],
          [:x, :x, :x]
        ]
      )
      expect(win_horizontal_game.execute).to eq('Player X has won the game!')
    end

    it 'can recognise when there is no horizontal win' do
      place_o_marker.execute(:o, [0, 0])
      place_x_marker.execute(:x, [2, 1])
      place_o_marker.execute(:o, [0, 1])
      place_x_marker.execute(:x, [2, 2])

      expect(view_game.execute.grid).to eq(
        [
          [:o, :o, nil],
          [nil, nil, nil],
          [nil, :x, :x]
        ]
      )

      expect(win_horizontal_game.execute).to eq('No horizontal win.')
    end
  end
end
