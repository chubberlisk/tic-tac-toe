# frozen_string_literal: true

require 'spec_helper'

describe UseCase::EvaluateGame do
  let(:game_gateway) { GameGatewayStub.new }
  let(:evaluate_game) { UseCase::EvaluateGame.new(game_gateway) }
  let(:game) { Game.new }

  context 'when Player X wins horizontally' do
    it 'can win a game when player X has 3 in a row horizontally in the first row' do
      game.grid = [
        %i[x x x],
        [:o, :o, nil],
        [nil, nil, nil]
      ]

      game_gateway.saved_game = game

      evaluate_game_response = evaluate_game.execute({})

      expect(evaluate_game_response[:outcome]).to eq(:player_x_win)
    end

    it 'can win a game when player X has 3 in a row horizontally in the second row' do
      game.grid = [
        [:o, :o, nil],
        %i[x x x],
        [nil, nil, nil]
      ]

      game_gateway.saved_game = game

      evaluate_game_response = evaluate_game.execute({})

      expect(evaluate_game_response[:outcome]).to eq(:player_x_win)
    end

    it 'can win a game when player X has 3 in a row horizontally in the last row' do
      game.grid = [
        [:o, :o, nil],
        [nil, nil, nil],
        %i[x x x]
      ]

      game_gateway.saved_game = game

      evaluate_game_response = evaluate_game.execute({})

      expect(evaluate_game_response[:outcome]).to eq(:player_x_win)
    end
  end

  context 'when Player O wins horizontally' do
    it 'can win a game when player O has 3 in a row horizontally in the first row' do
      game.grid = [
        %i[o o o],
        [:x, :x, nil],
        [nil, nil, nil]
      ]

      game_gateway.saved_game = game

      evaluate_game_response = evaluate_game.execute({})

      expect(evaluate_game_response[:outcome]).to eq(:player_o_win)
    end

    it 'can win a game when player O has 3 in a row horizontally in the second row' do
      game.grid = [
        [:x, :x, nil],
        %i[o o o],
        [nil, nil, nil]
      ]

      game_gateway.saved_game = game

      evaluate_game_response = evaluate_game.execute({})

      expect(evaluate_game_response[:outcome]).to eq(:player_o_win)
    end

    it 'can win a game when player O has 3 in a row horizontally in the third row' do
      game.grid = [
        [:x, :x, nil],
        [nil, nil, nil],
        %i[o o o]
      ]

      game_gateway.saved_game = game

      evaluate_game_response = evaluate_game.execute({})

      expect(evaluate_game_response[:outcome]).to eq(:player_o_win)
    end
  end

  context 'when Player X wins vertically' do
    it 'can win a game when player X has 3 in a column vertically in the first column' do
      game.grid = [
        %i[x o o],
        [:x, nil, nil],
        [:x, nil, nil]
      ]

      game_gateway.saved_game = game

      evaluate_game_response = evaluate_game.execute({})

      expect(evaluate_game_response[:outcome]).to eq(:player_x_win)
    end

    it 'can win a game when player X has 3 in a column vertically in the second column' do
      game.grid = [
        [nil, :x, nil],
        [nil, :x, :o],
        [:o, :x, nil]
      ]

      game_gateway.saved_game = game

      evaluate_game_response = evaluate_game.execute({})

      expect(evaluate_game_response[:outcome]).to eq(:player_x_win)
    end

    it 'can win a game when player X has 3 in a column vertically in the last column' do
      game.grid = [
        [nil, nil, :x],
        [:o, nil, :x],
        [:o, nil, :x]
      ]

      game_gateway.saved_game = game

      evaluate_game_response = evaluate_game.execute({})

      expect(evaluate_game_response[:outcome]).to eq(:player_x_win)
    end
  end

  context 'when Player O wins vertically' do
    it 'can win a game when player O has 3 in a column vertically in the first column' do
      game.grid = [
        [:o, nil, nil],
        [:o, :x, nil],
        [:o, nil, :x]
      ]

      game_gateway.saved_game = game

      evaluate_game_response = evaluate_game.execute({})

      expect(evaluate_game_response[:outcome]).to eq(:player_o_win)
    end

    it 'can win a game when player O has 3 in a column vertically in the second column' do
      game.grid = [
        [:x, :o, nil],
        [nil, :o, :x],
        [nil, :o, nil]
      ]

      game_gateway.saved_game = game

      evaluate_game_response = evaluate_game.execute({})

      expect(evaluate_game_response[:outcome]).to eq(:player_o_win)
    end

    it 'can win a game when player O has 3 in a column vertically in the third column' do
      game.grid = [
        [nil, :x, :o],
        [:x, nil, :o],
        [nil, nil, :o]
      ]

      game_gateway.saved_game = game

      evaluate_game_response = evaluate_game.execute({})

      expect(evaluate_game_response[:outcome]).to eq(:player_o_win)
    end
  end

  context 'when Player X wins diagonally' do
    it 'can win a game when player X has 3 in a row diagonally from bottom left to top right' do
      game.grid = [
        [:o, nil, :x],
        [nil, :x, nil],
        [:x, nil, :o]
      ]

      game_gateway.saved_game = game

      evaluate_game_response = evaluate_game.execute({})

      expect(evaluate_game_response[:outcome]).to eq(:player_x_win)
    end

    it 'can win a game when player X has 3 in a row diagonally from top left to bottom right' do
      game.grid = [
        [:x, nil, nil],
        [nil, :x, :o],
        [:o, nil, :x]
      ]

      game_gateway.saved_game = game

      evaluate_game_response = evaluate_game.execute({})

      expect(evaluate_game_response[:outcome]).to eq(:player_x_win)
    end
  end

  context 'when Player O wins diagonally' do
    it 'can win a game when player o has 3 in a row diagonally from bottom left to top right' do
      game.grid = [
        [:x, nil, :o],
        [nil, :o, :x],
        [:o, nil, nil]
      ]

      game_gateway.saved_game = game

      evaluate_game_response = evaluate_game.execute({})

      expect(evaluate_game_response[:outcome]).to eq(:player_o_win)
    end

    it 'can win a game when player O has 3 in a row diagonally from top left to bottom right' do
      game.grid = [
        [:o, nil, :x],
        [:x, :o, nil],
        [nil, nil, :o]
      ]

      game_gateway.saved_game = game

      evaluate_game_response = evaluate_game.execute({})

      expect(evaluate_game_response[:outcome]).to eq(:player_o_win)
    end

    it 'can win a game on the games last turn' do
      game.grid = [
        %i[o o x],
        %i[x o o],
        %i[x o x]
      ]

      game_gateway.saved_game = game

      evaluate_game_response = evaluate_game.execute({})

      expect(evaluate_game_response[:outcome]).to eq(:player_o_win)
    end
  end

  context 'when there is not a winner' do
    it 'can recognise when there is no horizontal win' do
      game.grid = [
        %i[x o x],
        [:o, :o, nil],
        [nil, nil, nil]
      ]

      game_gateway.saved_game = game

      evaluate_game_response = evaluate_game.execute({})

      expect(evaluate_game_response[:outcome]).to eq(:continue)
    end

    it 'can recognise when there is no vertical win' do
      game.grid = [
        [:x, :o, nil],
        [nil, nil, :x],
        [nil, :o, nil]
      ]

      game_gateway.saved_game = game

      evaluate_game_response = evaluate_game.execute({})

      expect(evaluate_game_response[:outcome]).to eq(:continue)
    end
  end

  context 'when there is a draw' do
    it 'can draw a game' do
      game.grid = [
        %i[x x o],
        %i[o o x],
        %i[x o x]
      ]

      game_gateway.saved_game = game

      evaluate_game_response = evaluate_game.execute({})

      expect(evaluate_game_response[:outcome]).to eq(:draw)
    end

    it 'can draw a game for a different grid' do
      game.grid = [
        %i[x o o],
        %i[o x x],
        %i[o x o]
      ]

      game_gateway.saved_game = game

      evaluate_game_response = evaluate_game.execute({})

      expect(evaluate_game_response[:outcome]).to eq(:draw)
    end
  end
end
