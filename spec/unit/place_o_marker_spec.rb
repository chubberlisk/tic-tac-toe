require_relative '../../lib/place_o_marker'
require_relative '../../lib/game'

describe PlaceOMarker do
  class GameGatewayStubAndSpy
    attr_accessor :saved_game

    def save(game)
      @saved_game = game
    end
  end

  let(:game_gateway) { GameGatewayStubAndSpy.new }
  let(:place_o_marker) { PlaceOMarker.new(game_gateway) }
  let(:empty_grid) do
    [
      [nil, nil, nil],
      [nil, nil, nil],
      [nil, nil, nil]
    ]
  end

  it 'can retrieve the grid' do
    game_gateway.saved_game = Game.new(empty_grid)

    place_o_marker.execute(nil)

    expect(place_o_marker.grid).to eq(empty_grid)
  end

  it 'can place O marker at (0, 0) on the grid' do
    game_gateway.saved_game = Game.new(empty_grid)

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
    game_gateway.saved_game = Game.new(empty_grid)

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
