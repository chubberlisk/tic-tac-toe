require_relative '../test_doubles/game_gateway_fake'
require_relative '../../lib/place_marker'
require_relative '../../lib/game'

describe PlaceMarker do
  let(:game_gateway) { GameGatewayFake.new }
  let(:place_x_marker) { PlaceMarker.new(game_gateway) }
  let(:place_o_marker) { PlaceMarker.new(game_gateway) }
  let(:empty_grid) do
    [
      [nil, nil, nil],
      [nil, nil, nil],
      [nil, nil, nil]
    ]
  end

  before { game_gateway.saved_game = Game.new(empty_grid) }

  context 'place X marker' do
    it 'can place X marker at (2, 1) on the grid' do
      place_x_marker.execute(:x, [2, 1])

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
    it 'can place O marker at (0, 0) on the grid' do
      place_o_marker.execute(:o, [0, 0])

      expect(game_gateway.saved_game.grid).to eq(
        [
          [:o, nil, nil],
          [nil, nil, nil],
          [nil, nil, nil]
        ]
      )
    end

    it 'can place O marker at (1, 2) on the grid' do
      place_o_marker.execute(:o, [1, 2])

      expect(game_gateway.saved_game.grid).to eq(
        [
          [nil, nil, nil],
          [nil, nil, :o],
          [nil, nil, nil]
        ]
      )
    end
  end

  context 'raise error' do
    it 'can raise an error when a O marker is placed at (2, 1) on a taken position' do
      place_x_marker.execute(:o, [2, 1])
      expect { place_o_marker.execute(:x, [2, 1]) }.to raise_error(PlaceMarker::InvalidMoveError)
    end

    it 'can raise an error when a O marker is placed at (2, 2) on a taken position' do
      place_x_marker.execute(:o, [2, 2])
      expect { place_o_marker.execute(:x, [2, 2]) }.to raise_error(PlaceMarker::InvalidMoveError)
    end

    it 'can raise an error when an X marker is placed at (0, 1) on a taken position' do
      place_o_marker.execute(:x, [0, 1])
      expect { place_x_marker.execute(:o, [0, 1]) }.to raise_error(PlaceMarker::InvalidMoveError)
    end

    it 'can raise an error when an X marker is placed at (1, 1) on a taken position' do
      place_o_marker.execute(:x, [1, 1])
      expect { place_x_marker.execute(:o, [1, 1]) }.to raise_error(PlaceMarker::InvalidMoveError)
    end
  end
end
