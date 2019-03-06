class Grid
  attr_accessor :state

  def initialize
    @state = [
      [nil, nil, nil],
      [nil, nil, nil],
      [nil, nil, nil]
    ]
  end

  def win?(marker)
    horizontal_win?(marker) || vertical_win?(marker) || diagonal_win?(marker)
  end

  def draw?
    @state.each { |row| return false if empty_space_in?(row) }
    true
  end

  private

  def horizontal_win?(marker)
    @state[0][0..2].all?(marker) || @state[1][0..2].all?(marker)\
      || @state[2][0..2].all?(marker)
  end

  def vertical_win?(marker)
    grid_column(0).all?(marker) || grid_column(1).all?(marker)\
      || grid_column(2).all?(marker)
  end

  def diagonal_win?(marker)
    positive_diagonal.all?(marker) || negative_diagonal.all?(marker)
  end

  def empty_space_in?(row)
    row.include?(nil)
  end

  def grid_column(index)
    [@state[0][index], @state[1][index], @state[2][index]]
  end

  def positive_diagonal
    [@state[0][2], @state[1][1], @state[2][0]]
  end

  def negative_diagonal
    [@state[0][0], @state[1][1], @state[2][2]]
  end
end
