require_relative '../../lib/place_marker'
require_relative '../../lib/game'

describe PlaceMarker do
  class GameGatewayStubAndSpy
    attr_accessor :saved_game

    def save(game)
      @saved_game = game
    end
  end

  let(:game_gateway) { GameGatewayStubAndSpy.new }
  let(:empty_grid) do
    [
      [nil, nil, nil],
      [nil, nil, nil],
      [nil, nil, nil]
    ]
  end

  before { game_gateway.saved_game = Game.new(empty_grid) }

  context 'place X marker' do
    let(:place_x_marker) { PlaceMarker.new(game_gateway, :x) }

    it 'can retrieve the grid' do
      place_x_marker.execute(nil)

      expect(place_x_marker.grid).to eq(empty_grid)
    end

    it 'can place X marker at (0, 0) on the grid' do
      place_x_marker.execute([0, 0])

      expect(game_gateway.saved_game.grid).to eq(
        [
          [:x, nil, nil],
          [nil, nil, nil],
          [nil, nil, nil]
        ]
      )
    end

    it 'can place X marker at (2, 1) on the grid' do
      place_x_marker.execute([2, 1])

      expect(game_gateway.saved_game.grid).to eq(
        [
          [nil, nil, nil],
          [nil, nil, nil],
          [nil, :x, nil]
        ]
      )
    end
  end

  context 'place O marker' do
    let(:place_o_marker) { PlaceMarker.new(game_gateway, :o) }

    it 'can retrieve the grid' do
      place_o_marker.execute(nil)

      expect(place_o_marker.grid).to eq(empty_grid)
    end

    it 'can place O marker at (0, 0) on the grid' do
      place_o_marker.execute([0, 0])

      expect(game_gateway.saved_game.grid).to eq(
        [
          [:o, nil, nil],
          [nil, nil, nil],
          [nil, nil, nil]
        ]
      )
    end

    it 'can place O marker at (1, 2) on the grid' do
      place_o_marker.execute([1, 2])

      expect(game_gateway.saved_game.grid).to eq(
        [
          [nil, nil, nil],
          [nil, nil, :o],
          [nil, nil, nil]
        ]
      )
    end
  end
end
