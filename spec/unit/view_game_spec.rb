require "spec_helper"

describe ViewGrid do
  it 'can view a grid' do
    grid_gateway = GridGatewayStub.new
    view_grid = ViewGrid.new(grid_gateway)

    grid_gateway.saved_grid = Grid.new

    expect(view_grid.execute.state).to eq(
      [
        [nil, nil, nil],
        [nil, nil, nil],
        [nil, nil, nil]
      ]
    )
  end
end
