class EvaluateGrid
  def initialize(grid_gateway)
    @grid_gateway = grid_gateway
  end

  def execute
    grid = @grid_gateway.retrieve
    
    return :player_x_win if grid.win?(:x)
    return :player_o_win if grid.win?(:o)
    return :draw if grid.draw?
    
    :no_win
  end
end
