# frozen_string_literal: true
require 'spec_helper'

describe 'Tic Tac Toe' do
  # let(:grid_gateway) { GridGatewayFake.new }
  # let(:create_new_grid) { CreateNewGrid.new(grid_gateway) }
  # let(:view_grid) { ViewGrid.new(grid_gateway) }
  # let(:take_turn) { Placeposition: er.new(grid_gateway) }
  let(:game_gateway) { GameGatewayFake.new }
  let(:start_new_game) { UseCase::StartNewGame.new(game_gateway) }
  let(:take_turn) { UseCase::TakeTurn.new(game_gateway) }
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

  context 'when a game has started' do
    before do
      game_options = { first_player: :player_x }

      start_new_game.execute(game_options)
    end
    it 'can take a turn' do
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
  end

  context 'when a player wins horizontally' do
    let(:evaluate_game) { UseCase::EvaluateGame.new(game_gateway) }

    before do
      game_options = { first_player: :player_x }
      start_new_game.execute(game_options)
    end

    it 'can win a game when player X has 3 in a row horizontally in the first row' do
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
          [:x, :x, :x],
          [:o, :o, nil],
          [nil, nil, nil]
        ]
      )

      evaluate_game_response = evaluate_game.execute({})

      expect(evaluate_game_response[:outcome]).to eq(:player_x_win)
    end

    # it 'can win a game when player X has 3 in a row horizontally in the second row' do
    #   take_turn.execute(position: [1, 0])
    #   take_turn.execute(position: [0, 0])
    #   take_turn.execute(position: [1, 1])
    #   take_turn.execute(position: [0, 1])
    #   take_turn.execute(position: [1, 2])

    #   view_grid_response = view_grid.execute({})

    #   expect(view_grid_response[:grid]).to eq(
    #     [
    #       [:o, :o, nil],
    #       [:x, :x, :x],
    #       [nil, nil, nil]
    #     ]
    #   )

    #   evaluate_game_response = evaluate_game.execute({})

    #   expect(evaluate_game_response[:outcome]).to eq(:player_x_win)
    # end

    # it 'can win a game when player X has 3 in a row horizontally in the third row' do
    #   take_turn.execute(position: [2, 0])
    #   take_turn.execute(position: [0, 0])
    #   take_turn.execute(position: [2, 1])
    #   take_turn.execute(position: [0, 1])
    #   take_turn.execute(position: [2, 2])

    #   view_grid_response = view_grid.execute({})

    #   expect(view_grid_response[:grid]).to eq(
    #     [
    #       [:o, :o, nil],
    #       [nil, nil, nil],
    #       [:x, :x, :x]
    #     ]
    #   )

    #   evaluate_game_response = evaluate_game.execute({})

    #   expect(evaluate_game_response[:outcome]).to eq(:player_x_win)
    # end

    # it 'can win a game when player O has 3 in a row horizontally in the first row' do
    #   take_turn.execute(position: [0, 0])
    #   take_turn.execute(position: [1, 0])
    #   take_turn.execute(position: [0, 1])
    #   take_turn.execute(position: [1, 1])
    #   take_turn.execute(position: [0, 2])

    #   view_grid_response = view_grid.execute({})

    #   expect(view_grid_response[:grid]).to eq(
    #     [
    #       [:o, :o, :o],
    #       [:x, :x, nil],
    #       [nil, nil, nil]
    #     ]
    #   )

    #   evaluate_game_response = evaluate_game.execute({})

    #   expect(evaluate_game_response[:outcome]).to eq(:player_o_win)
    # end

    # it 'can win a game when player O has 3 in a row horizontally in the second row' do
    #   take_turn.execute(position: [1, 0])
    #   take_turn.execute(position: [0, 0])
    #   take_turn.execute(position: [1, 1])
    #   take_turn.execute(position: [0, 1])
    #   take_turn.execute(position: [1, 2])

    #   view_grid_response = view_grid.execute({})

    #   expect(view_grid_response[:grid]).to eq(
    #     [
    #       [:o, :o, nil],
    #       [:x, :x, :x],
    #       [nil, nil, nil]
    #     ]
    #   )

    #   evaluate_game_response = evaluate_game.execute({})

    #   expect(evaluate_game_response[:outcome]).to eq(:player_x_win)
    # end

    # it 'can win a game when player O has 3 in a row horizontally in the third row' do
    #   take_turn.execute(position: [2, 0])
    #   take_turn.execute(position: [0, 0])
    #   take_turn.execute(position: [2, 1])
    #   take_turn.execute(position: [0, 1])
    #   take_turn.execute(position: [2, 2])

    #   view_grid_response = view_grid.execute({})

    #   expect(view_grid_response[:grid]).to eq(
    #     [
    #       [:o, :o, nil],
    #       [nil, nil, nil],
    #       [:x, :x, :x]
    #     ]
    #   )

    #   evaluate_game_response = evaluate_game.execute({})

    #   expect(evaluate_game_response[:outcome]).to eq(:player_x_win)
    # end

    # it 'can recognise when there is no horizontal win' do
    #   take_turn.execute(position: [0, 0])
    #   take_turn.execute(position: [2, 1])
    #   take_turn.execute(position: [0, 1])
    #   take_turn.execute(position: [2, 2])

    #   view_grid_response = view_grid.execute({})

    #   expect(view_grid_response[:grid]).to eq(
    #     [
    #       [:o, :o, nil],
    #       [nil, nil, nil],
    #       [nil, :x, :x]
    #     ]
    #   )

    #   evaluate_game_response = evaluate_game.execute({})

    #   expect(evaluate_game_response[:outcome]).to eq(:continue)
    # end
  end

  # context 'when a player wins vertically' do
  #   let(:evaluate_game) { EvaluateGame.new(grid_gateway) }

  #   before { grid_gateway.saved_grid = Grid.new }

  #   it 'can win a game when player X has 3 in a row vertically in the first column' do
  #     take_turn.execute(position: [0, 0])
  #     take_turn.execute(position: [0, 1])
  #     take_turn.execute(position: [1, 0])
  #     take_turn.execute(position: [0, 2])
  #     take_turn.execute(position: [2, 0])

  #     view_grid_response = view_grid.execute({})

  #     expect(view_grid_response[:grid]).to eq(
  #       [
  #         [:x, :o, :o],
  #         [:x, nil, nil],
  #         [:x, nil, nil]
  #       ]
  #     )

  #     evaluate_game_response = evaluate_game.execute({})

  #     expect(evaluate_game_response[:outcome]).to eq(:player_x_win)
  #   end

  #   it 'can win a game when player X has 3 in a row vertically in the second column' do
  #     take_turn.execute(position: [0, 1])
  #     take_turn.execute(position: [1, 0])
  #     take_turn.execute(position: [1, 1])
  #     take_turn.execute(position: [2, 0])
  #     take_turn.execute(position: [2, 1])

  #     view_grid_response = view_grid.execute({})

  #     expect(view_grid_response[:grid]).to eq(
  #       [
  #         [nil, :x, nil],
  #         [:o, :x, nil],
  #         [:o, :x, nil]
  #       ]
  #     )

  #     evaluate_game_response = evaluate_game.execute({})

  #     expect(evaluate_game_response[:outcome]).to eq(:player_x_win)
  #   end

  #   it 'can win a game when player X has 3 in a row vertically in the third column' do
  #     take_turn.execute(position: [0, 2])
  #     take_turn.execute(position: [0, 1])
  #     take_turn.execute(position: [1, 2])
  #     take_turn.execute(position: [2, 0])
  #     take_turn.execute(position: [2, 2])

  #     view_grid_response = view_grid.execute({})

  #     expect(view_grid_response[:grid]).to eq(
  #       [
  #         [nil, :o, :x],
  #         [nil, nil, :x],
  #         [:o, nil, :x]
  #       ]
  #     )

  #     evaluate_game_response = evaluate_game.execute({})

  #     expect(evaluate_game_response[:outcome]).to eq(:player_x_win)
  #   end

  #   it 'can win a game when player O has 3 in a row horizontally in the first column' do
  #     take_turn.execute(position: [0, 0])
  #     take_turn.execute(position: [0, 1])
  #     take_turn.execute(position: [1, 0])
  #     take_turn.execute(position: [2, 1])
  #     take_turn.execute(position: [2, 0])

  #     view_grid_response = view_grid.execute({})

  #     expect(view_grid_response[:grid]).to eq(
  #       [
  #         [:o, :x, nil],
  #         [:o, nil, nil],
  #         [:o, :x, nil]
  #       ]
  #     )

  #     evaluate_game_response = evaluate_game.execute({})

  #     expect(evaluate_game_response[:outcome]).to eq(:player_o_win)
  #   end

  #   it 'can win a game when player O has 3 in a row vertically in the second column' do
  #     take_turn.execute(position: [0, 1])
  #     take_turn.execute(position: [1, 0])
  #     take_turn.execute(position: [1, 1])
  #     take_turn.execute(position: [1, 2])
  #     take_turn.execute(position: [2, 1])

  #     view_grid_response = view_grid.execute({})

  #     expect(view_grid_response[:grid]).to eq(
  #       [
  #         [nil, :o, nil],
  #         [:x, :o, :x],
  #         [nil, :o, nil]
  #       ]
  #     )

  #     evaluate_game_response = evaluate_game.execute({})

  #     expect(evaluate_game_response[:outcome]).to eq(:player_o_win)
  #   end

  #   it 'can win a game when player O has 3 in a row vertically in the third column' do
  #     take_turn.execute(position: [0, 2])
  #     take_turn.execute(position: [0, 1])
  #     take_turn.execute(position: [1, 2])
  #     take_turn.execute(position: [2, 0])
  #     take_turn.execute(position: [2, 2])

  #     view_grid_response = view_grid.execute({})

  #     expect(view_grid_response[:grid]).to eq(
  #       [
  #         [nil, :x, :o],
  #         [nil, nil, :o],
  #         [:x, nil, :o]
  #       ]
  #     )

  #     evaluate_game_response = evaluate_game.execute({})

  #     expect(evaluate_game_response[:outcome]).to eq(:player_o_win)
  #   end

  #   it 'can recognise when there is no vertical win' do
  #     take_turn.execute(position: [0, 0])
  #     take_turn.execute(position: [0, 1])
  #     take_turn.execute(position: [1, 2])
  #     take_turn.execute(position: [2, 1])

  #     view_grid_response = view_grid.execute({})

  #     expect(view_grid_response[:grid]).to eq(
  #       [
  #         [:o, :x, nil],
  #         [nil, nil, :o],
  #         [nil, :x, nil]
  #       ]
  #     )

  #     evaluate_game_response = evaluate_game.execute({})

  #     expect(evaluate_game_response[:outcome]).to eq(:continue)
  #   end
  # end

  # context 'when a player wins diagonally' do
  #   let(:evaluate_game) { EvaluateGame.new(grid_gateway) }

  #   before { grid_gateway.saved_grid = Grid.new }

  #   it 'can win a game when player X has 3 in a row diagonally from bottom left to top right' do
  #     take_turn.execute(position: [2, 0])
  #     take_turn.execute(position: [0, 0])
  #     take_turn.execute(position: [1, 1])
  #     take_turn.execute(position: [1, 2])
  #     take_turn.execute(position: [0, 2])

  #     view_grid_response = view_grid.execute({})

  #     expect(view_grid_response[:grid]).to eq(
  #       [
  #         [:o, nil, :x],
  #         [nil, :x, :o],
  #         [:x, nil, nil]
  #       ]
  #     )

  #     evaluate_game_response = evaluate_game.execute({})

  #     expect(evaluate_game_response[:outcome]).to eq(:player_x_win)
  #   end

  #   it 'can win a game when player X has 3 in a row diagonally from top left to bottom right' do
  #     take_turn.execute(position: [0, 0])
  #     take_turn.execute(position: [1, 0])
  #     take_turn.execute(position: [1, 1])
  #     take_turn.execute(position: [2, 0])
  #     take_turn.execute(position: [2, 2])

  #     view_grid_response = view_grid.execute({})

  #     expect(view_grid_response[:grid]).to eq(
  #       [
  #         [:x, nil, nil],
  #         [:o, :x, nil],
  #         [:o, nil, :x]
  #       ]
  #     )

  #     evaluate_game_response = evaluate_game.execute({})

  #     expect(evaluate_game_response[:outcome]).to eq(:player_x_win)
  #   end

  #   it 'can win a game when player O has 3 in a row diagonally from bottom left to top right' do
  #     take_turn.execute(position: [2, 0])
  #     take_turn.execute(position: [0, 0])
  #     take_turn.execute(position: [1, 1])
  #     take_turn.execute(position: [1, 2])
  #     take_turn.execute(position: [0, 2])

  #     view_grid_response = view_grid.execute({})

  #     expect(view_grid_response[:grid]).to eq(
  #       [
  #         [:x, nil, :o],
  #         [nil, :o, :x],
  #         [:o, nil, nil]
  #       ]
  #     )

  #     evaluate_game_response = evaluate_game.execute({})

  #     expect(evaluate_game_response[:outcome]).to eq(:player_o_win)
  #   end

  #   it 'can win a game when player O has 3 in a row diagonally from top left to bottom right' do
  #     take_turn.execute(position: [0, 0])
  #     take_turn.execute(position: [1, 0])
  #     take_turn.execute(position: [1, 1])
  #     take_turn.execute(position: [0, 2])
  #     take_turn.execute(position: [2, 2])

  #     view_grid_response = view_grid.execute({})

  #     expect(view_grid_response[:grid]).to eq(
  #       [
  #         [:o, nil, :x],
  #         [:x, :o, nil],
  #         [nil, nil, :o]
  #       ]
  #     )

  #     evaluate_game_response = evaluate_game.execute({})

  #     expect(evaluate_game_response[:outcome]).to eq(:player_o_win)
  #   end
  # end

  # context 'when an error is raised' do
  #   before { grid_gateway.saved_grid = Grid.new }

  #   it 'cannot place a marker in a position that already has a marker' do
  #     take_turn.execute(position: [2, 1])

  #     view_grid_response = view_grid.execute({})

  #     expect(view_grid_response[:grid]).to eq(
  #       [
  #         [nil, nil, nil],
  #         [nil, nil, nil],
  #         [nil, :x, nil]
  #       ]
  #     )

  #     expect { take_turn.execute(position: [2, 1]) }.to raise_error(PlaceMarker::InvalidMoveError)
  #     expect(view_grid_response[:grid]).to eq(
  #       [
  #         [nil, nil, nil],
  #         [nil, nil, nil],
  #         [nil, :x, nil]
  #       ]
  #     )
  #   end

  #   it 'cannot place a marker in a position that is outside the grid' do
  #     expect { take_turn.execute(position: [-6, 1]) }.to raise_error(PlaceMarker::InvalidPositionError)

  #     view_grid_response = view_grid.execute({})

  #     expect(view_grid_response[:grid]).to eq(empty_grid)

  #     expect { take_turn.execute(position: [3, 0]) }.to raise_error(PlaceMarker::InvalidPositionError)

  #     view_grid_response = view_grid.execute({})

  #     expect(view_grid_response[:grid]).to eq(empty_grid)

  #     expect { take_turn.execute(position: [2, -3]) }.to raise_error(PlaceMarker::InvalidPositionError)

  #     view_grid_response = view_grid.execute({})

  #     expect(view_grid_response[:grid]).to eq(empty_grid)

  #     expect { take_turn.execute(position: [2, 7]) }.to raise_error(PlaceMarker::InvalidPositionError)

  #     view_grid_response = view_grid.execute({})

  #     expect(view_grid_response[:grid]).to eq(empty_grid)
  #   end

  #   it 'can alert Player X that it is not their turn to place a marker' do
  #     take_turn.execute(position: [1, 1])
  #     expect { take_turn.execute(position: [0, 1]) }.to raise_error(PlaceMarker::InvalidTurnError)
  #   end

  #   it 'can alert Player O that it is not their turn to place a marker' do
  #     take_turn.execute(position: [2, 2])
  #     expect { take_turn.execute(position: [0, 0]) }.to raise_error(PlaceMarker::InvalidTurnError)
  #   end
  # end

  # context 'when the players draw' do
  #   let(:evaluate_game) { EvaluateGame.new(grid_gateway) }

  #   before { grid_gateway.saved_grid = Grid.new }

  #   it 'can draw a game when no player has won' do
  #     take_turn.execute(position: [0, 0])
  #     take_turn.execute(position: [0, 1])
  #     take_turn.execute(position: [0, 2])
  #     take_turn.execute(position: [1, 0])
  #     take_turn.execute(position: [1, 2])
  #     take_turn.execute(position: [1, 1])
  #     take_turn.execute(position: [2, 0])
  #     take_turn.execute(position: [2, 2])
  #     take_turn.execute(position: [2, 1])

  #     view_grid_response = view_grid.execute({})

  #     expect(view_grid_response[:grid]).to eq(
  #       [
  #         [:x, :o, :x],
  #         [:o, :o, :x],
  #         [:x, :x, :o]
  #       ]
  #     )

  #     evaluate_game_response = evaluate_game.execute({})

  #     expect(evaluate_game_response[:outcome]).to eq(:draw)
  #   end
  # end
end
