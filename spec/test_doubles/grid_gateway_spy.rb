class GridGatewaySpy
  attr_reader :saved_grid

  def save(grid)
    @saved_grid = grid
  end
end
