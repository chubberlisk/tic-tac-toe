require 'terminal-table'
require 'cli/ui'
require 'zeitwerk'

loader = Zeitwerk::Loader.new
loader.push_dir(__dir__)
loader.setup

class GameGateway
  attr_accessor :saved_game

  def retrieve
    @saved_game.dup
  end

  def save(game)
    @saved_game = game
  end
end

class UIInterface
  def initialize
    CLI::UI::StdoutRouter.enable
  end

  def open_frame(text = '')
    CLI::UI::Frame.open(text)
  end

  def close_frame(text = '')
    CLI::UI::Frame.close(text)
  end

  def add_divider(text = '')
    CLI::UI::Frame.divider(text)
  end

  def ask(question, options)
    CLI::UI::Prompt.ask(question) do |handler|
      options.each do |option|
        handler.option(option[:name]) { option[:value] }
      end
    end
  end

  def format_text(text = '', colour)
    CLI::UI.fmt("{{#{colour}:#{text}}}")
  end

  def format_error(text = '')
    CLI::UI.fmt("{{x}} ") + format_text(text, 'red')
  end
end

class CommandLineUI
  def initialize(start_new_game:, evaluate_game:, take_turn:, ui_interface:)
    @start_new_game = start_new_game
    @evaluate_game = evaluate_game
    @take_turn = take_turn
    @ui_interface = ui_interface
  end

  def execute
    @ui_interface.open_frame('Tic Tac Toe')

    question = 'Which player should go first?'
    options = [
      { name: 'Player X', value: :player_x},
      { name: 'Player O', value: :player_o}
    ]
    first_player = @ui_interface.ask(question, options)

    start_new_game_response = @start_new_game.execute(first_player: first_player)
    display_game_screen(start_new_game_response)

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
      position = @ui_interface.ask(question, options)

      take_turn_response = @take_turn.execute(position: position)
      display_game_screen(take_turn_response)
    end

    evaluate_game_response = @evaluate_game.execute({})
    display_end_screen(evaluate_game_response)

    @ui_interface.close_frame
  end

  private

  def create_terminal_table(grid)
    temp_grid = grid.map do |row|
      row.map { |x| x || ' ' }
    end

    Terminal::Table.new do |t|
      temp_grid.each_with_index do |row, i|
        t.add_row(row)
        t.add_separator if i + 1 < temp_grid.length
      end
    end
  end

  def display_game_screen(response)
    player = response[:player_turn] == :player_x ? 'Player X' : 'Player O'
    @ui_interface.add_divider("#{player} Turn")
    puts create_terminal_table(response[:grid])
    puts
    puts @ui_interface.format_error(response[:error].to_s) if response[:error]
    puts
  end

  def display_end_screen(response)
    @ui_interface.add_divider('Game Over')

    if response[:outcome] == :player_x_win
      puts @ui_interface.format_text('Player X wins!', 'green')
    elsif response[:outcome] == :player_o_win
      puts @ui_interface.format_text('Player O wins!', 'green')
    else
      puts @ui_interface.format_text('It\'s a draw!', 'yellow')
    end
  end
end

game_gateway = GameGateway.new
start_new_game = UseCase::StartNewGame.new(game_gateway)
evaluate_game = UseCase::EvaluateGame.new(game_gateway)
take_turn = UseCase::TakeTurn.new(game_gateway)
ui_interface = UIInterface.new

command_line_ui = CommandLineUI.new(
  start_new_game: start_new_game,
  evaluate_game: evaluate_game,
  take_turn: take_turn,
  ui_interface: ui_interface
)

command_line_ui.execute
