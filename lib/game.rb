class Game
  attr_accessor :grid

  def initialize(grid)
    @grid = grid
  end

  def win
    return :player_x_win if win?(:x)
    return :player_o_win if win?(:o)

    :no_win
  end

  private

  def win?(marker)
    horizontal_win?(marker) || vertical_win?(marker)
  end

  def horizontal_win?(marker)
    @grid[0][0..2].all?(marker) || @grid[1][0..2].all?(marker)\
      || @grid[2][0..2].all?(marker)
  end

  def vertical_win?(marker)
    grid_column(0).all?(marker) || grid_column(1).all?(marker)\
      || grid_column(2).all?(marker)
  end

  def grid_column(index)
    [@grid[0][index], @grid[1][index], @grid[2][index]]
  end
end
