# frozen_string_literal: true

require 'terminal-table'
require 'cli/ui'

class Ui::UiInterface
  def initialize
    @turn_options = [
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
    CLI::UI::StdoutRouter.enable
    open_frame('Tic Tac Toe')
  end

  def ask_user_for_first_player
    question = 'Which player should go first?'
    options = [
      { name: 'Player X', value: :player_x },
      { name: 'Player O', value: :player_o }
    ]
    ask(question: question, options: options)
  end

  def ask_user_for_position
    question = 'Where thy place marker?'
    response = ask(question: question, options: @turn_options)
    @turn_options = @turn_options.reject { |option| option[:value] == response }
    response
  end

  def display_game_screen(response)
    player = response[:player_turn] == :player_x ? 'Player X' : 'Player O'
    add_divider("#{player} Turn")
    puts create_terminal_table(response[:grid])
    puts
    puts format_error(response[:error].to_s) if response[:error]
    puts
  end

  def display_end_screen(response)
    add_divider('Game Over')
    if response[:outcome] == :player_x_win
      puts format_text('Player X wins!', 'green')
    elsif response[:outcome] == :player_o_win
      puts format_text('Player O wins!', 'green')
    else
      puts format_text('It\'s a draw!', 'yellow')
    end
    close_frame
  end

  private

  def ask(question:, options:)
    CLI::UI::Prompt.ask(question) do |handler|
      options.each do |option|
        handler.option(option[:name]) { option[:value] }
      end
      handler.option('Quit') do
        close_frame
        exit
      end
    end
  end

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

  def open_frame(text = '')
    CLI::UI::Frame.open(text)
  end

  def close_frame(text = '')
    CLI::UI::Frame.close(text)
  end

  def add_divider(text = '')
    CLI::UI::Frame.divider(text)
  end

  def format_text(text = '', colour)
    CLI::UI.fmt("{{#{colour}:#{text}}}")
  end

  def format_error(text = '')
    CLI::UI.fmt('{{x}} ') + format_text(text, 'red')
  end
end
