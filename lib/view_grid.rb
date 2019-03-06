class ViewGrid
  def initialize(grid_gateway)
    @grid_gateway = grid_gateway
  end

  def execute(*)
    {
      grid: @grid_gateway.retrieve
    }
  end
end
