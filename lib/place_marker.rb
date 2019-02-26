class PlaceMarker
  InvalidMoveError = Class.new(RuntimeError)

  def initialize(game_gateway)
    @game_gateway = game_gateway
  end

  def execute(marker, position)
    grid = @game_gateway.saved_game.grid
    return if position.nil?

    raise InvalidMoveError if already_taken?(grid, position)

    grid[position[0]][position[1]] = marker

    game = Game.new(grid)
    @game_gateway.save(game)
  end

  private

  def already_taken?(grid, position)
    grid[position[0]][position[1]]
  end
end
