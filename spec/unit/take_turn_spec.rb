describe UseCase::TakeTurn do
  it 'can take the first turn in a game for Player X' do
    game_options = {
      first_player: :player_x
    }

    game = Game.new(game_options)

    game_gateway = GameGatewayFake.new
    game_gateway.saved_game = game

    take_turn = UseCase::TakeTurn.new(game_gateway)

    turn_options = {
      position: [1, 0]
    }

    response = take_turn.execute(turn_options)

    expect(response[:grid]).to eq([
      [nil, nil, nil],
      [:x, nil, nil],
      [nil, nil, nil]
    ])
  end

  it 'can take the first turn in a game for Player O' do
    game_options = {
      first_player: :player_o
    }

    game = Game.new(game_options)

    game_gateway = GameGatewayFake.new
    game_gateway.saved_game = game

    take_turn = UseCase::TakeTurn.new(game_gateway)

    turn_options = {
      position: [2, 2]
    }

    response = take_turn.execute(turn_options)

    expect(response[:grid]).to eq([
      [nil, nil, nil],
      [nil, nil, nil],
      [nil, nil, :o]
    ])
  end

  it 'can give the current player turn when Player X goes first' do
    game_options = {
      first_player: :player_x
    }

    game = Game.new(game_options)

    game_gateway = GameGatewayFake.new
    game_gateway.saved_game = game

    take_turn = UseCase::TakeTurn.new(game_gateway)

    turn_options = {
      position: [1, 0]
    }

    response = take_turn.execute(turn_options)

    expect(response[:player_turn]).to eq(:player_o)
  end

  it 'can give the current player turn when Player O goes first' do
    game_options = {
      first_player: :player_o
    }

    game = Game.new(game_options)

    game_gateway = GameGatewayFake.new
    game_gateway.saved_game = game

    take_turn = UseCase::TakeTurn.new(game_gateway)

    turn_options = {
      position: [1, 0]
    }

    response = take_turn.execute(turn_options)

    expect(response[:player_turn]).to eq(:player_x)
  end

  it 'returns an error message when a turn is made outside of the grid' do
    game_options = {
      first_player: :player_o
    }

    game = Game.new(game_options)

    game_gateway = GameGatewayFake.new
    game_gateway.saved_game = game

    take_turn = UseCase::TakeTurn.new(game_gateway)

    turn_options = {
      position: [100, 0]
    }

    response = take_turn.execute(turn_options)

    expect(response[:error]).to eq("Please place your marker inside the grid")
  end

  it 'returns an error message when a turn is made on a taken tile' do
    game_options = {
      first_player: :player_o
    }

    game = Game.new(game_options)

    game_gateway = GameGatewayFake.new
    game_gateway.saved_game = game

    take_turn = UseCase::TakeTurn.new(game_gateway)

    turn_options = {
      position: [1, 0]
    }

    response = take_turn.execute(turn_options)
    response = take_turn.execute(turn_options)

    expect(response[:error]).to eq("That tile is already taken, please select another")
  end
end
