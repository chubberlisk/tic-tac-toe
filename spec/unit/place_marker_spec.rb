# frozen_string_literal: true

require 'spec_helper'

describe UseCase::PlaceMarker do
  let(:game_gateway) { GameGatewayFake.new }
  let(:place_marker) { UseCase::PlaceMarker.new }
  let(:game) { Domain::Game.new }
  let(:options) do
    {
      player_turn: game.player_turn,
      grid: game.grid,
      position: [0, 0]
    }
  end
  let(:empty_grid) do
    [
      [nil, nil, nil],
      [nil, nil, nil],
      [nil, nil, nil]
    ]
  end

  before { game_gateway.saved_game = game }

  it 'can place X marker at (2, 1) on the grid' do
    options[:position] = [2, 1]

    place_marker.execute(options)

    expect(game_gateway.saved_game.grid).to eq(
      [
        [nil, nil, nil],
        [nil, nil, nil],
        [nil, :x, nil]
      ]
    )
  end

  it 'can place X marker at (0, 1) on the grid' do
    options[:position] = [0, 1]

    place_marker.execute(options)

    expect(game_gateway.saved_game.grid).to eq(
      [
        [nil, :x, nil],
        [nil, nil, nil],
        [nil, nil, nil]
      ]
    )
  end

  it 'can place O marker at (0, 0) on the grid' do
    options[:player_turn] = :player_o
    options[:position] = [0, 0]

    place_marker.execute(options)

    expect(game_gateway.saved_game.grid).to eq(
      [
        [:o, nil, nil],
        [nil, nil, nil],
        [nil, nil, nil]
      ]
    )
  end

  it 'can place O marker at (2, 2) on the grid' do
    options[:player_turn] = :player_o
    options[:position] = [2, 2]

    place_marker.execute(options)

    expect(game_gateway.saved_game.grid).to eq(
      [
        [nil, nil, nil],
        [nil, nil, nil],
        [nil, nil, :o]
      ]
    )
  end

  context 'when marker is placed on a taken position' do
    it 'can raise an error when an X marker is placed at (2, 1) on a taken position' do
      options[:player_turn] = :player_o
      options[:position] = [2, 1]

      place_marker.execute(options)

      options[:player_turn] = :player_x
      expect { place_marker.execute(options) }.to raise_error(UseCase::PlaceMarker::InvalidMoveError)
    end

    it 'can raise an error when an X marker is placed at (2, 2) on a taken position' do
      options[:player_turn] = :player_o
      options[:position] = [2, 2]

      place_marker.execute(options)

      options[:player_turn] = :player_x
      expect { place_marker.execute(options) }.to raise_error(UseCase::PlaceMarker::InvalidMoveError)
    end

    it 'can raise an error when an O marker is placed at (0, 1) on a taken position' do
      options[:player_turn] = :player_x
      options[:position] = [0, 1]

      place_marker.execute(options)

      options[:player_turn] = :player_o
      expect { place_marker.execute(options) }.to raise_error(UseCase::PlaceMarker::InvalidMoveError)
    end

    it 'can raise an error when an O marker is placed at (1, 1) on a taken position' do
      options[:player_turn] = :player_x
      options[:position] = [1, 1]

      place_marker.execute(options)

      options[:player_turn] = :player_o
      expect { place_marker.execute(options) }.to raise_error(UseCase::PlaceMarker::InvalidMoveError)
    end
  end

  context 'when marker is placed outside the grid' do
    it 'can raise an error when an X marker is placed outside of the X coordinate of the grid' do
      options[:player_turn] = :player_x
      options[:position] = [3, 0]

      expect { place_marker.execute(options) }.to raise_error(UseCase::PlaceMarker::InvalidPositionError)
    end

    it 'can raise an error when an X marker is placed outside of the X coordinate of the grid' do
      options[:player_turn] = :player_x
      options[:position] = [6, 1]

      expect { place_marker.execute(options) }.to raise_error(UseCase::PlaceMarker::InvalidPositionError)
    end

    it 'can raise an error when an X marker is placed outside of the X coordinate of the grid' do
      options[:player_turn] = :player_x
      options[:position] = [-1, 2]

      expect { place_marker.execute(options) }.to raise_error(UseCase::PlaceMarker::InvalidPositionError)
    end

    it 'can raise an error when an X marker is placed outside of the Y coordinate of the grid' do
      options[:player_turn] = :player_x
      options[:position] = [1, 4]

      expect { place_marker.execute(options) }.to raise_error(UseCase::PlaceMarker::InvalidPositionError)
    end

    it 'can raise an error when an X marker is placed outside of the Y coordinate of the grid' do
      options[:player_turn] = :player_x
      options[:position] = [1, -1]

      expect { place_marker.execute(options) }.to raise_error(UseCase::PlaceMarker::InvalidPositionError)
    end
  end
end
