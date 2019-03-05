class PlaceMarker
  InvalidMoveError = Class.new(RuntimeError)
  InvalidPositionError = Class.new(RuntimeError)
  InvalidTurnError = Class.new(RuntimeError)

  def initialize(game_gateway)
    @game_gateway = game_gateway
  end

  def execute(marker, position)
    raise InvalidPositionError unless inside_grid?(position)

    grid = @game_gateway.saved_game.grid

    raise InvalidTurnError if not_players_turn?(grid, marker)

    raise InvalidMoveError if already_taken?(grid, position)

    grid[position[0]][position[1]] = marker

    game = Game.new(grid)
    @game_gateway.save(game)
  end

  private

  def already_taken?(grid, position)
    grid[position[0]][position[1]]
  end

  def inside_grid?(position)
    position[0].between?(0, 2) && position[1].between?(0, 2)
  end

  def not_players_turn?(grid, marker)
    total_x_count = grid.reduce(0) { |total, row| total + row.count(:x) }
    total_o_count = grid.reduce(0) { |total, row| total + row.count(:o) }
    total_x_count > total_o_count && marker == :x
    total_x_count < total_o_count && marker == :o
    if marker == :x
      total_x_count > total_o_count
    else
      total_x_count < total_o_count
    end
  end
end
