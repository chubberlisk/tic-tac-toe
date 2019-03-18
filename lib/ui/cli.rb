# frozen_string_literal: true

require 'terminal-table'
require 'cli/ui'

class UI::CLI
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
    CLI::UI::Frame.open('Tic Tac Toe')
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
    CLI::UI::Frame.divider("#{player} Turn")
    grid = convert_marker_symbols_to_strings(response[:grid])
    puts create_terminal_table(grid)
    puts
  end

  def display_end_screen(response)
    CLI::UI::Frame.divider('Game Over')
    if response[:outcome] == :player_x_win
      puts format_text('Player X wins!', 'green')
    elsif response[:outcome] == :player_o_win
      puts format_text('Player O wins!', 'green')
    else
      puts format_text('It\'s a draw!', 'magenta')
    end
    CLI::UI::Frame.close('')
  end

  private

  def ask(question:, options:)
    CLI::UI::Prompt.ask(question) do |handler|
      options.each do |option|
        handler.option(option[:name]) { option[:value] }
      end
      handler.option('Quit') do
        CLI::UI::Frame.close('')
        exit
      end
    end
  end

  def convert_marker_symbols_to_strings(grid)
    grid.map do |row|
      row.map do |marker|
        if marker == :x
          format_text(marker.upcase, 'red')
        elsif marker == :o
          format_text(marker.upcase, 'yellow')
        else
          ' '
        end
      end
    end
  end

  def create_terminal_table(grid)
    Terminal::Table.new do |t|
      grid.each.with_index(1) do |row, i|
        t.add_row(row)
        t.add_separator if i < grid.length
      end
    end
  end

  def format_text(text, colour)
    CLI::UI.fmt("{{#{colour}:#{text}}}")
  end
end
