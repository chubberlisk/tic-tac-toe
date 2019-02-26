class Game
  attr_accessor :grid

  def initialize(grid)
    @grid = grid
  end

  def horizontal_win
    return :player_x_win if win?(:x)
    return :player_o_win if win?(:o)

    :no_win
  end

  private

  def win?(marker)
    @grid[0][0..2].all?(marker) || @grid[1][0..2].all?(marker)\
      || @grid[2][0..2].all?(marker)
  end
end
