# frozen_string_literal: true
require_relative  '../../lib/start_new_game'
require_relative  '../../lib/view_game'

describe 'Tic Tac Toe' do
  class InMemoryGameGateway
    attr_reader :saved_game

    def save(game)
      @saved_game = game
    end
  end

  it 'can start a new game' do
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
end
