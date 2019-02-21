class PlaceMarker
  attr_reader :grid

  def initialize(game_gateway, marker)
    @game_gateway = game_gateway
    @marker = marker
  end

  def execute(position)
    @grid = @game_gateway.saved_game.grid
    return if position.nil?

    @grid[position[0]][position[1]] = @marker

    game = Game.new(@grid)
    @game_gateway.save(game)
  end
end
