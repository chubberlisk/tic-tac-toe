require_relative '../../lib/save_grid'

describe SaveGrid do
  class GridGatewaySpy
    attr_reader :last_grid_saved

    def save(grid)
      @last_grid_saved = grid
    end
  end

  it 'can save a grid' do
    grid_gateway = GridGatewaySpy.new
    save_grid = SaveGrid.new(grid_gateway: grid_gateway)

    save_grid.execute({
      row_one: [nil, nil, nil],
      row_two: [nil, nil, nil],
      row_three: [nil, nil, nil]
    })

    last_grid = grid_gateway.last_grid_saved

    expect(last_grid.view).to eq({
      row_one: [nil, nil, nil],
      row_two: [nil, nil, nil],
      row_three: [nil, nil, nil]
    })
  end

  it 'can save a grid example 2' do
    grid_gateway = GridGatewaySpy.new
    save_grid = SaveGrid.new(grid_gateway: grid_gateway)

    save_grid.execute({
      row_one: [:x, nil, nil],
      row_two: [nil, :o, nil],
      row_three: [nil, :x, nil]
    })

    last_grid = grid_gateway.last_grid_saved

    expect(last_grid.view).to eq({
      row_one: [:x, nil, nil],
      row_two: [nil, :o, nil],
      row_three: [nil, :x, nil]
    })
  end
end
