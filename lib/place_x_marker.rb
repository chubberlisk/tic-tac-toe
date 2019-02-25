class PlaceXMarker
  attr_reader :grid

  def initialize(game_gateway)
    @game_gateway = game_gateway
  end

  def execute(position)
    @grid = @game_gateway.saved_game.grid
    return if position.nil?

    @grid[position[0]][position[1]] = :x

    game = Game.new(@grid)
    @game_gateway.save(game)
  end
end
