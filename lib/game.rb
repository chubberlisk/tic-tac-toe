class Game
  attr_accessor :grid

  def initialize(grid)
    @grid = grid
  end

  def horizontal_win
    if winner
      "Player #{winner} has won the game!"
    else
      'No horizontal win.'
    end
  end

  private

  def winner
    if win?(:x)
      'X'
    elsif win?(:o)
      'O'
    end
  end

  def win?(marker)
    @grid[0][0..2].all?(marker) || @grid[1][0..2].all?(marker) || @grid[2][0..2].all?(marker)
  end
end
