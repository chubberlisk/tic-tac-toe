class GridGatewayStub
  attr_writer :saved_grid

  def retrieve
    @saved_grid.dup
  end
end
