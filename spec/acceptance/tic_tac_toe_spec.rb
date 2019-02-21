# frozen_string_literal: true
require_relative  '../../lib/start_new_game'
require_relative  '../../lib/view_game'
require_relative  '../../lib/place_x_marker'

describe 'Tic Tac Toe' do
  class InMemoryGameGateway
    attr_accessor :saved_game

    def save(game)
      @saved_game = game
    end
  end

  it 'can start and view a new game' do
    game_gateway = InMemoryGameGateway.new
    start_new_game = StartNewGame.new(game_gateway)
    view_game = ViewGame.new(game_gateway)

    start_new_game.execute

    expect(view_game.execute.grid).to eq(
      [
        [nil, nil, nil],
        [nil, nil, nil],
        [nil, nil, nil]
      ]
    )
  end

  it 'can place an X marker in a position on the grid' do
    game_gateway = InMemoryGameGateway.new
    place_x_marker = PlaceXMarker.new(game_gateway)
    view_game = ViewGame.new(game_gateway)
    game_gateway.saved_game = Game.new(
      [
        [nil, nil, nil],
        [nil, nil, nil],
        [nil, nil, nil]
      ]
    )

    place_x_marker.execute([0, 0])

    expect(view_game.execute.grid).to eq(
      [
        [:x, nil, nil],
        [nil, nil, nil],
        [nil, nil, nil]
      ]
    )
  end
end
