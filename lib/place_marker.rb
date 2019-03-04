class PlaceMarker
  InvalidMoveError = Class.new(RuntimeError)
  InvalidPositionError = Class.new(RuntimeError)

  def initialize(game_gateway)
    @game_gateway = game_gateway
  end

  def execute(marker, position)
    raise InvalidPositionError unless inside_grid?(position)

    grid = @game_gateway.saved_game.grid

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
end
