# frozen_string_literal: true

class CommandLineUi
  def initialize(start_new_game:, evaluate_game:, take_turn:, ui_interface:)
    @start_new_game = start_new_game
    @evaluate_game = evaluate_game
    @take_turn = take_turn
    @ui_interface = ui_interface
  end

  def execute
    first_player = @ui_interface.ask_user_for_first_player
    start_new_game_response = @start_new_game.execute(first_player: first_player)
    @ui_interface.display_game_screen(start_new_game_response)

    while @evaluate_game.execute({})[:outcome] == :continue
      position = @ui_interface.ask_user_for_position
      take_turn_response = @take_turn.execute(position: position)
      @ui_interface.display_game_screen(take_turn_response)
    end

    evaluate_game_response = @evaluate_game.execute({})
    @ui_interface.display_end_screen(evaluate_game_response)
  end
end
