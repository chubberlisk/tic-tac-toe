require 'grid'

class SaveGrid
  def initialize(grid_gateway:)
    @grid_gateway = grid_gateway
  end

  def execute(foo)
    grid = Grid.new(foo)
    @grid_gateway.save(grid)
  end
end
