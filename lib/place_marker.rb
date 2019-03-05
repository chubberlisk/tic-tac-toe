class PlaceMarker
  InvalidMoveError = Class.new(RuntimeError)
  InvalidPositionError = Class.new(RuntimeError)
  InvalidTurnError = Class.new(RuntimeError)

  def initialize(game_gateway)
    @game_gateway = game_gateway
    @player_turn = nil
    @number_of_turns = 0
  end

  def execute(marker, position)
    @player_turn = marker if first_turn?

    grid = @game_gateway.saved_game.grid

    validate_place_marker(grid, marker, position)

    place_marker_on_grid(grid, marker, position)

    game = Game.new(grid)
    @game_gateway.save(game)

    update_player_turn
  end

  private

  def already_taken?(grid, position)
    grid[position[0]][position[1]]
  end

  def inside_grid?(position)
    position[0].between?(0, 2) && position[1].between?(0, 2)
  end

  def first_turn?
    @number_of_turns.zero?
  end

  def validate_place_marker(grid, marker, position)
    raise InvalidTurnError if @player_turn != marker
    raise InvalidPositionError unless inside_grid?(position)
    raise InvalidMoveError if already_taken?(grid, position)
  end

  def place_marker_on_grid(grid, marker, position)
    grid[position[0]][position[1]] = marker
  end

  def update_player_turn
    @player_turn = @player_turn == :x ? :o : :x
    @number_of_turns += 1
  end
end
