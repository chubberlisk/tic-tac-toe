class Game
  attr_reader :grid, :player_turn

  def initialize(game_options)
    @player_turn = game_options[:first_player]
    @grid = [
      [nil, nil, nil],
      [nil, nil, nil],
      [nil, nil, nil]
    ]
  end
end
