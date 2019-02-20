class PlaceXMarker
  attr_reader :grid

  def initialize(game_gateway)
    @game_gateway = game_gateway
  end

  def execute(position)
    @game = @game_gateway.saved_game
    @grid = @game.grid
    return nil if position.nil?
    @grid[position[0]][position[1]] = :x
    @game.grid = @grid
    @game_gateway.saved_game = @game
  end
end
