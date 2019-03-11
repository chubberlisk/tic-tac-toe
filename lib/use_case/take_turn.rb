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

 
    updated_grid = place_marker.execute(place_marker_options)

    game.grid = updated_grid[:grid]
    game.player_turn = game.player_turn == :player_x ? :player_o  : :player_x
    @game_gateway.save(game)


    {
      grid: game.grid,
      player_turn: game.player_turn
    }
  end
end
