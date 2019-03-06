class EvaluateGrid
  def initialize(grid_gateway)
    @grid_gateway = grid_gateway
  end

  def execute(*)
    grid = @grid_gateway.retrieve

    outcome = :no_win
    outcome = :draw if grid.draw?
    outcome = :player_x_win if grid.win?(:x)
    outcome = :player_o_win if grid.win?(:o)

    {
      outcome: outcome
    }
  end
end
