require 'grid'

class CreateNewGrid
  def initialize(grid_gateway)
    @grid_gateway = grid_gateway
  end

  def execute
    @grid_gateway.save(Grid.new)
  end
end
