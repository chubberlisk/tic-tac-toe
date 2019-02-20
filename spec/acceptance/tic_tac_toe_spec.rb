# frozen_string_literal: true

describe 'Tic Tac Toe' do
  class InMemoryGridGateway
  end

  it 'can view a grid' do
    grid = {
      row_one: [nil, nil, nil],
      row_two: [nil, nil, nil],
      row_three: [nil, nil, nil]
    }

    grid_gateway = InMemoryGridGateway.new
    save_grid = SaveGrid.new(grid_gateway: grid_gateway)
    view_grid = ViewGrid.new(grid_gateway: grid_gateway)

    response = save_grid.execute(grid)

    view_grid_response = view_grid.execute(id: response[:id])

    expect(view_grid_response).to eq(
      {
        id: response[:id],
        grid: {
          row_one: [nil, nil, nil],
          row_two: [nil, nil, nil],
          row_three: [nil, nil, nil]
        }
      }
    )
  end
end
