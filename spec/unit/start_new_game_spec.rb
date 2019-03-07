describe UseCase::StartNewGame do
  let(:game_gateway) { GameGatewaySpy.new }
  let(:start_new_game) { UseCase::StartNewGame.new(game_gateway) }

  it 'can create a new grid' do
    game_options = {
      first_player: :player_x
    }

    response = start_new_game.execute(game_options)

    saved_grid = game_gateway.saved_game.grid

    expect(response[:grid]).to eq(saved_grid)
  end

  it 'can set starting player (Player X)' do
    game_options = {
      first_player: :player_x
    }

    response = start_new_game.execute(game_options)

    saved_player_turn = game_gateway.saved_game.player_turn

    expect(response[:player_turn]).to eq(saved_player_turn)
  end

  it 'can set starting player (Player O)' do
    game_options = {
      first_player: :player_o
    }

    response = start_new_game.execute(game_options)

    saved_player_turn = game_gateway.saved_game.player_turn

    expect(response[:player_turn]).to eq(saved_player_turn)
  end
end
