# frozen_string_literal: true

class UseCase::PlaceMarker
  InvalidMoveError = Class.new(RuntimeError)
  InvalidPositionError = Class.new(RuntimeError)

  def execute(options)
    player_turn = options[:player_turn]
    grid = options[:grid]
    position = options[:position]

    validate_place_marker(grid, position)

    marker = player_turn == :player_x ? :x : :o

    grid[position[0]][position[1]] = marker

    {
      grid: grid
    }
  end

  private

  def inside_grid?(position)
    position[0].between?(0, 2) && position[1].between?(0, 2)
  end

  def already_taken?(grid, position)
    grid[position[0]][position[1]]
  end

  def validate_place_marker(grid, position)
    raise InvalidPositionError unless inside_grid?(position)
    raise InvalidMoveError if already_taken?(grid, position)
  end
end
