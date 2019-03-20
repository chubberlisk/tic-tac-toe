# frozen_string_literal: true

require 'spec_helper'

describe 'Tic Tac Toe' do
  let(:game_gateway) { Gateway::InMemoryGame.new }
  let(:start_new_game) { UseCase::StartNewGame.new(game_gateway) }
  let(:place_marker) { UseCase::PlaceMarker.new }
  let(:take_turn) { UseCase::TakeTurn.new(game_gateway, place_marker) }
  let(:evaluate_game) { UseCase::EvaluateGame.new(game_gateway) }
  let(:empty_grid) do
    [
      [nil, nil, nil],
      [nil, nil, nil],
      [nil, nil, nil]
    ]
  end

  it 'can start a new game' do
    game_options = { first_player: :player_x }

    response = start_new_game.execute(game_options)

    expect(response[:grid]).to eq(empty_grid)
    expect(response[:player_turn]).to eq(:player_x)
  end

  it 'can take a turn' do
    game_options = { first_player: :player_x }
    start_new_game.execute(game_options)

    turn_options = { position: [0, 1] }
    response = take_turn.execute(turn_options)

    expect(response[:grid]).to eq(
      [
        [nil, :x, nil],
        [nil, nil, nil],
        [nil, nil, nil]
      ]
    )
    expect(response[:player_turn]).to eq(:player_o)
  end

  it 'can take two turns' do
    game_options = { first_player: :player_x }
    start_new_game.execute(game_options)

    turn_options = { position: [0, 1] }
    take_turn.execute(turn_options)

    turn_options = { position: [1, 1] }
    response = take_turn.execute(turn_options)

    expect(response[:grid]).to eq(
      [
        [nil, :x, nil],
        [nil, :o, nil],
        [nil, nil, nil]
      ]
    )
    expect(response[:player_turn]).to eq(:player_x)
  end

  it 'can win a game when a player has 3 in a row horizontally' do
    game_options = { first_player: :player_x }
    start_new_game.execute(game_options)

    turn_options = { position: [0, 0] }
    take_turn.execute(turn_options)

    turn_options = { position: [1, 0] }
    take_turn.execute(turn_options)

    turn_options = { position: [0, 1] }
    take_turn.execute(turn_options)

    turn_options = { position: [1, 1] }
    take_turn.execute(turn_options)

    turn_options = { position: [0, 2] }
    take_turn_response = take_turn.execute(turn_options)

    expect(take_turn_response[:grid]).to eq(
      [
        %i[x x x],
        [:o, :o, nil],
        [nil, nil, nil]
      ]
    )

    evaluate_game_response = evaluate_game.execute({})

    expect(evaluate_game_response[:outcome]).to eq(:player_x_win)
  end

  it 'can win a game when a player has 3 in a row vertically' do
    game_options = { first_player: :player_o }
    start_new_game.execute(game_options)

    turn_options = { position: [0, 1] }
    take_turn.execute(turn_options)

    turn_options = { position: [1, 0] }
    take_turn.execute(turn_options)

    turn_options = { position: [1, 1] }
    take_turn.execute(turn_options)

    turn_options = { position: [0, 2] }
    take_turn.execute(turn_options)

    turn_options = { position: [2, 1] }
    take_turn_response = take_turn.execute(turn_options)

    expect(take_turn_response[:grid]).to eq(
      [
        [nil, :o, :x],
        [:x, :o, nil],
        [nil, :o, nil]
      ]
    )

    evaluate_game_response = evaluate_game.execute({})

    expect(evaluate_game_response[:outcome]).to eq(:player_o_win)
  end

  it 'can win a game when a player has 3 in a row diagonally' do
    game_options = { first_player: :player_x }
    start_new_game.execute(game_options)

    turn_options = { position: [0, 0] }
    take_turn.execute(turn_options)

    turn_options = { position: [0, 1] }
    take_turn.execute(turn_options)

    turn_options = { position: [1, 1] }
    take_turn.execute(turn_options)

    turn_options = { position: [2, 0] }
    take_turn.execute(turn_options)

    turn_options = { position: [2, 2] }
    take_turn_response = take_turn.execute(turn_options)

    expect(take_turn_response[:grid]).to eq(
      [
        [:x, :o, nil],
        [nil, :x, nil],
        [:o, nil, :x]
      ]
    )

    evaluate_game_response = evaluate_game.execute({})

    expect(evaluate_game_response[:outcome]).to eq(:player_x_win)
  end

  it 'can draw a game when no player has won' do
    game_options = { first_player: :player_o }
    start_new_game.execute(game_options)

    turn_options = { position: [0, 1] }
    take_turn.execute(turn_options)

    turn_options = { position: [0, 0] }
    take_turn.execute(turn_options)

    turn_options = { position: [1, 0] }
    take_turn.execute(turn_options)

    turn_options = { position: [0, 2] }
    take_turn.execute(turn_options)

    turn_options = { position: [1, 1] }
    take_turn.execute(turn_options)

    turn_options = { position: [2, 1] }
    take_turn.execute(turn_options)

    turn_options = { position: [2, 0] }
    take_turn.execute(turn_options)

    turn_options = { position: [1, 2] }
    take_turn.execute(turn_options)

    turn_options = { position: [2, 2] }
    take_turn_response = take_turn.execute(turn_options)

    expect(take_turn_response[:grid]).to eq(
      [
        %i[x o x],
        %i[o o x],
        %i[o x o]
      ]
    )

    evaluate_game_response = evaluate_game.execute({})

    expect(evaluate_game_response[:outcome]).to eq(:draw)
  end
end
