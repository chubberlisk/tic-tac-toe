class GridGatewayFake
  attr_accessor :saved_grid

  def save(grid)
    @saved_grid = grid
  end
end
