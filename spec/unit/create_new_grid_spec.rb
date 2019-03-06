require "spec_helper"

describe CreateNewGrid do
  it 'creates a new grid' do
    grid_gateway = GridGatewaySpy.new
    start_new_game = CreateNewGrid.new(grid_gateway)

    start_new_game.execute({})

    expect(grid_gateway.saved_grid.state).to eq(
      [
        [nil, nil, nil],
        [nil, nil, nil],
        [nil, nil, nil]
      ]
    )
  end
end
