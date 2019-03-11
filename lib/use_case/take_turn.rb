# frozen_string_literal: true

class UseCase::TakeTurn
  def initialize(game_gateway)
    @game_gateway = game_gateway
  end

  def execute(options)
    game = @game_gateway.retrieve

    place_marker_options = {
      player_turn: game.player_turn,
      grid: game.grid,
      position: options[:position]
    }

    place_marker = UseCase::PlaceMarker.new
    error = nil
    begin
      updated_grid = place_marker.execute(place_marker_options)
    rescue UseCase::PlaceMarker::InvalidPositionError
      error = 'Please place your marker inside the grid.'
    rescue UseCase::PlaceMarker::InvalidMoveError
      error = 'That tile is already taken, please select another.'
    else
      game.grid = updated_grid[:grid]
      game.player_turn = game.player_turn == :player_x ? :player_o : :player_x
      @game_gateway.save(game)
    end

    {
      grid: game.grid,
      player_turn: game.player_turn,
      error: error
    }
  end
end
