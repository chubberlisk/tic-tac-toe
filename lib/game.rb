class Game
  attr_accessor :grid, :player_turn

  def initialize(game_options = { first_player: :player_x })
    @player_turn = game_options[:first_player]
    @grid = [
      [nil, nil, nil],
      [nil, nil, nil],
      [nil, nil, nil]
    ]
  end
end
