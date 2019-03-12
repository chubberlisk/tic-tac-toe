class CommandLineUi
  def initialize(start_new_game:, evaluate_game:, take_turn:, ui_interface:)
    @start_new_game = start_new_game
    @evaluate_game = evaluate_game
    @take_turn = take_turn
    @ui_interface = ui_interface
  end

  def execute
    question = 'Which player should go first?'
    options = [
      { name: 'Player X', value: :player_x},
      { name: 'Player O', value: :player_o}
    ]
    first_player = @ui_interface.ask(question: question, options: options)

    start_new_game_response = @start_new_game.execute(first_player: first_player)
    @ui_interface.display_game_screen(start_new_game_response)

    while @evaluate_game.execute({})[:outcome] == :continue
      question = 'Where thy place marker?'
      options = [
        { name: 'Top Left', value: [0, 0] },
        { name: 'Top Centre', value: [0, 1] },
        { name: 'Top Right', value: [0, 2] },
        { name: 'Centre Left', value: [1, 0] },
        { name: 'Centre Centre', value: [1, 1] },
        { name: 'Centre Right', value: [1, 2] },
        { name: 'Bottom Left', value: [2, 0] },
        { name: 'Bottom Centre', value: [2, 1] },
        { name: 'Bottom Right', value: [2, 2] }
      ]
      position = @ui_interface.ask(question: question, options: options)
      take_turn_response = @take_turn.execute(position: position)
      @ui_interface.display_game_screen(take_turn_response)
    end

    evaluate_game_response = @evaluate_game.execute({})
    @ui_interface.display_end_screen(evaluate_game_response)
  end
end