class UserInterface::Presenter
  def initialize(start_new_game:, evaluate_game:, take_turn:, user_interface:)
    @start_new_game = start_new_game
    @evaluate_game = evaluate_game
    @take_turn = take_turn
    @ui = user_interface
  end

  def execute(*)
    first_player = @ui.ask_user_for_first_player
    start_new_game_response = @start_new_game.execute(first_player: first_player)
    @ui.display_turn(start_new_game_response)
  end
end
