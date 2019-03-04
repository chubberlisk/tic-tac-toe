require_relative '../test_doubles/game_gateway_fake'
require_relative '../../lib/place_marker'
require_relative '../../lib/game'

describe PlaceMarker do
  let(:game_gateway) { GameGatewayFake.new }
  let(:place_marker) { PlaceMarker.new(game_gateway) }
  let(:empty_grid) do
    [
      [nil, nil, nil],
      [nil, nil, nil],
      [nil, nil, nil]
    ]
  end

  before { game_gateway.saved_game = Game.new(empty_grid) }

  context 'when an X marker is placed' do
    it 'can place X marker at (2, 1) on the grid' do
      place_marker.execute(:x, [2, 1])

      expect(game_gateway.saved_game.grid).to eq(
        [
          [nil, nil, nil],
          [nil, nil, nil],
          [nil, :x, nil]
        ]
      )
    end
  end

  context 'when an O marker is placed' do
    it 'can place O marker at (0, 0) on the grid' do
      place_marker.execute(:o, [0, 0])

      expect(game_gateway.saved_game.grid).to eq(
        [
          [:o, nil, nil],
          [nil, nil, nil],
          [nil, nil, nil]
        ]
      )
    end

    it 'can place O marker at (1, 2) on the grid' do
      place_marker.execute(:o, [1, 2])

      expect(game_gateway.saved_game.grid).to eq(
        [
          [nil, nil, nil],
          [nil, nil, :o],
          [nil, nil, nil]
        ]
      )
    end
  end

  context 'when marker is placed on a taken position' do
    it 'can raise an error when an X marker is placed at (2, 1) on a taken position' do
      place_marker.execute(:o, [2, 1])
      expect { place_marker.execute(:x, [2, 1]) }.to raise_error(PlaceMarker::InvalidMoveError)
    end

    it 'can raise an error when an X marker is placed at (2, 2) on a taken position' do
      place_marker.execute(:o, [2, 2])
      expect { place_marker.execute(:x, [2, 2]) }.to raise_error(PlaceMarker::InvalidMoveError)
    end

    it 'can raise an error when an O marker is placed at (0, 1) on a taken position' do
      place_marker.execute(:x, [0, 1])
      expect { place_marker.execute(:o, [0, 1]) }.to raise_error(PlaceMarker::InvalidMoveError)
    end

    it 'can raise an error when an O marker is placed at (1, 1) on a taken position' do
      place_marker.execute(:x, [1, 1])
      expect { place_marker.execute(:o, [1, 1]) }.to raise_error(PlaceMarker::InvalidMoveError)
    end
  end

  context 'when marker is placed outside the grid' do
    it 'can raise an error when an X marker is placed outside of the X coordinate of the grid' do
      expect { place_marker.execute(:x, [3, 0]) }.to raise_error(PlaceMarker::InvalidPositionError)
    end

    it 'can raise an error when an X marker is placed outside of the X coordinate of the grid' do
      expect { place_marker.execute(:x, [6, 1]) }.to raise_error(PlaceMarker::InvalidPositionError)
    end

    it 'can raise an error when an X marker is placed outside of the X coordinate of the grid' do
      expect { place_marker.execute(:x, [-1, 2]) }.to raise_error(PlaceMarker::InvalidPositionError)
    end

    it 'can raise an error when an X marker is placed outside of the Y coordinate of the grid' do
      expect { place_marker.execute(:x, [1, 4]) }.to raise_error(PlaceMarker::InvalidPositionError)
    end

    it 'can raise an error when an X marker is placed outside of the Y coordinate of the grid' do
      expect { place_marker.execute(:x, [1, -1]) }.to raise_error(PlaceMarker::InvalidPositionError)
    end
  end
end
