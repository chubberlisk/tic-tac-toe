# frozen_string_literal: true

require 'terminal-table'
require 'cli/ui'

class Ui::UiInterface
  def initialize
    CLI::UI::StdoutRouter.enable
    open_frame('Tic Tac Toe')
  end

  def ask(question:, options:)
    CLI::UI::Prompt.ask(question) do |handler|
      options.each do |option|
        handler.option(option[:name]) { option[:value] }
      end
    end
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

  def open_frame(text = '')
    CLI::UI::Frame.open(text)
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
