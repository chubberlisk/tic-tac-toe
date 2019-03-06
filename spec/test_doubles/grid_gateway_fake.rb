class GridGatewayFake
  attr_accessor :saved_grid

  def retrieve
    @saved_grid.dup
  end

  def save(grid)
    @saved_grid = grid
  end
end
