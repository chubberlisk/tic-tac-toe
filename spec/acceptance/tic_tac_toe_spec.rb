# frozen_string_literal: true
require_relative '../../lib/start_new_game'
require_relative '../../lib/view_game'
require_relative '../../lib/place_marker'

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
  let(:place_x_marker) { PlaceMarker.new(game_gateway, :x) }
  let(:place_o_marker) { PlaceMarker.new(game_gateway, :o) }
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
      place_x_marker.execute([0, 0])

      expect(view_game.execute.grid).to eq(
        [
          [:x, nil, nil],
          [nil, nil, nil],
          [nil, nil, nil]
        ]
      )
    end

    it 'can place an O marker in a position on the grid' do
      place_o_marker.execute([2, 2])

      expect(view_game.execute.grid).to eq(
        [
          [nil, nil, nil],
          [nil, nil, nil],
          [nil, nil, :o]
        ]
      )
    end

    it 'can place an X and O marker in a position on the grid' do
      place_x_marker.execute([0, 2])
      place_o_marker.execute([1, 1])

      expect(view_game.execute.grid).to eq(
        [
          [nil, nil, :x],
          [nil, :o, nil],
          [nil, nil, nil]
        ]
      )
    end

    it 'cannot place a marker in a position that already has a marker' do
      place_x_marker.execute([2, 1])

      expect(view_game.execute.grid).to eq(
        [
          [nil, nil, nil],
          [nil, nil, nil],
          [nil, :x, nil]
        ]
      )

      expect { place_o_marker.execute([2, 1]) }.to raise_error(InvalidMoveError)

      expect(view_game.execute.grid).to eq(
        [
          [nil, nil, nil],
          [nil, nil, nil],
          [nil, :x, nil]
        ]
      )
    end
  end
end
