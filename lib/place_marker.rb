class PlaceMarker
  class InvalidMoveError < RuntimeError
  end

  attr_reader :grid

  def initialize(game_gateway, marker)
    @game_gateway = game_gateway
    @marker = marker
  end

  def execute(position)
    @grid = @game_gateway.saved_game.grid
    return if position.nil?

    raise InvalidMoveError if already_taken?(position)

    @grid[position[0]][position[1]] = @marker

    game = Game.new(@grid)
    @game_gateway.save(game)
  end

  private

  def already_taken?(position)
    !@grid[position[0]][position[1]].nil?
  end
end
