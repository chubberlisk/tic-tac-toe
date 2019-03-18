# frozen_string_literal: true

class Domain::Game
  attr_accessor :grid, :player_turn

  def initialize(first_player: :player_x)
    @player_turn = first_player
    @grid = [
      [nil, nil, nil],
      [nil, nil, nil],
      [nil, nil, nil]
    ]
  end
end
