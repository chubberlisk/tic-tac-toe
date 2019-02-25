class Game
  attr_accessor :grid

  def initialize(grid)
    @grid = grid
  end

  def horizontal_win
    winner ? "Player #{winner} has won the game!" : 'No horizontal win.'
  end

  private

  def winner
    return 'X' if win?(:x)

    'O' if win?(:o)
  end

  def win?(marker)
    @grid[0][0..2].all?(marker) || @grid[1][0..2].all?(marker)\
      || @grid[2][0..2].all?(marker)
  end
end
