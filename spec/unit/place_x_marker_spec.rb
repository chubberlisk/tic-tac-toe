require_relative '../../lib/place_x_marker'
require_relative '../../lib/game'

describe PlaceXMarker do
  class GameGatewayStubAndSpy
    attr_accessor :saved_game

    def save(game)
      @saved_game = game
    end
  end

  let(:game_gateway) { GameGatewayStubAndSpy.new }
  let(:place_x_marker) { PlaceXMarker.new(game_gateway) }
  let(:empty_grid) do
    [
      [nil, nil, nil],
      [nil, nil, nil],
      [nil, nil, nil]
    ]
  end

  it 'can retrieve the grid' do
    game_gateway.saved_game = Game.new(empty_grid)

    place_x_marker.execute(nil)

    expect(place_x_marker.grid).to eq(empty_grid)
  end

  it 'can place X marker at (0, 0) on the grid' do
    game_gateway.saved_game = Game.new(empty_grid)

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
    game_gateway.saved_game = Game.new(empty_grid)

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
