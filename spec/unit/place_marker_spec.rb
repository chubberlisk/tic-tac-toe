require_relative '../test_doubles/grid_gateway_fake'
require_relative '../../lib/place_marker'

describe PlaceMarker do
  let(:grid_gateway) { GridGatewayFake.new }
  let(:place_marker) { PlaceMarker.new(grid_gateway) }
  let(:empty_grid) do
    [
      [nil, nil, nil],
      [nil, nil, nil],
      [nil, nil, nil]
    ]
  end

  before { grid_gateway.saved_grid = Grid.new }

  context 'when an X marker is placed' do
    it 'can place X marker at (2, 1) on the grid' do
      place_marker.execute(:x, [2, 1])

      expect(grid_gateway.saved_grid.state).to eq(
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

      expect(grid_gateway.saved_grid.state).to eq(
        [
          [:o, nil, nil],
          [nil, nil, nil],
          [nil, nil, nil]
        ]
      )
    end

    it 'can place O marker at (1, 2) on the grid' do
      place_marker.execute(:o, [1, 2])

      expect(grid_gateway.saved_grid.state).to eq(
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

  context 'when it is not the turn of the player to place a marker' do
    it 'can raise an error when the Player X takes two turns in a row' do
      grid_gateway.saved_grid = Grid.new

      place_marker.execute(:x, [1, 1])
      place_marker.execute(:o, [0, 0])
      place_marker.execute(:x, [2, 1])

      expect { place_marker.execute(:x, [1, 2]) }.to raise_error(PlaceMarker::InvalidTurnError)
    end

    it 'can raise an error when the Player O takes two turns in a row' do
      grid_gateway.saved_grid = Grid.new

      place_marker.execute(:x, [0, 1])
      place_marker.execute(:o, [1, 1])

      expect { place_marker.execute(:o, [2, 1]) }.to raise_error(PlaceMarker::InvalidTurnError)
    end
  end
end
