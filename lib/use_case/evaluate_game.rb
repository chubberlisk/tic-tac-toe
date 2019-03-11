class UseCase::EvaluateGame
  def initialize(game_gateway)
    @game_gateway = game_gateway
  end

  def execute(*)
    game = @game_gateway.retrieve
    grid = game.grid

    outcome = :continue
    outcome = :draw if draw?(grid)
    outcome = :player_x_win if win?(grid, :x)
    outcome = :player_o_win if win?(grid, :o)

    {
      outcome: outcome
    }
  end

  private

  def win?(grid, marker)
    horizontal_win?(grid, marker) || vertical_win?(grid, marker) || diagonal_win?(grid, marker)
  end

  def draw?(grid)
    grid.each { |row| return false if empty_space_in?(row) }
    true
  end

  def horizontal_win?(grid, marker)
    grid[0][0..2].all?(marker) || grid[1][0..2].all?(marker)\
      || grid[2][0..2].all?(marker)
  end

  def vertical_win?(grid, marker)
    grid_column(grid, 0).all?(marker) || grid_column(grid, 1).all?(marker)\
      || grid_column(grid, 2).all?(marker)
  end

  def diagonal_win?(grid, marker)
    positive_diagonal(grid).all?(marker) || negative_diagonal(grid).all?(marker)
  end

  def empty_space_in?(row)
    row.include?(nil)
  end

  def grid_column(grid, index)
    [grid[0][index], grid[1][index], grid[2][index]]
  end

  def positive_diagonal(grid)
    [grid[0][2], grid[1][1], grid[2][0]]
  end

  def negative_diagonal(grid)
    [grid[0][0], grid[1][1], grid[2][2]]
  end
end
