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

class CommandLineUI
  def initialize(start_new_game:, evaluate_game:, take_turn:)
    @start_new_game = start_new_game
    @evaluate_game = evaluate_game
    @take_turn = take_turn
  end

  def execute()
    CLI::UI::StdoutRouter.enable
  
    CLI::UI::Frame.open('Tic Tac Toe') do
      first_player = CLI::UI::Prompt.ask('Which player should go first?') do |handler|
        handler.option('Player X') { :player_x }
        handler.option('Player O') { :player_o }
      end
    
      start_new_game_response = @start_new_game.execute(first_player: first_player)
      display_game_screen(start_new_game_response)

      while @evaluate_game.execute({})[:outcome] == :continue
        position = CLI::UI::Prompt.ask('Where thy place marker?') do |handler|
          handler.option('Top Left') { [0, 0] }
          handler.option('Top Centre') { [0, 1] }
          handler.option('Top Right') { [0, 2] }
          handler.option('Centre Left') { [1, 0] }
          handler.option('Centre Centre') { [1, 1] }
          handler.option('Centre Right') { [1, 2] }
          handler.option('Bottom Left') { [2, 0] }
          handler.option('Bottom Centre') { [2, 1] }
          handler.option('Bottom Right') { [2, 2] }
        end

        take_turn_response = @take_turn.execute(position: position)
        display_game_screen(take_turn_response)
      end
    
      evaluate_game_response = @evaluate_game.execute({})
      display_end_screen(evaluate_game_response)
    end
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
    CLI::UI::Frame.divider("#{player} Turn")
    puts create_terminal_table(response[:grid])
    puts
    puts CLI::UI.fmt "{{x}} {{red:#{response[:error]}}}\n\n" if response[:error]
  end

  def display_end_screen(response)
    CLI::UI::Frame.divider('Game Over')
    if response[:outcome] == :player_x_win
      puts CLI::UI.fmt "{{green:Player X wins!}}"
    elsif response[:outcome] == :player_o_win
      puts CLI::UI.fmt "{{green:Player O wins!}}"
    else
      puts CLI::UI.fmt "{{yellow:It's a draw!}}"
    end
  end
end

game_gateway = GameGateway.new
start_new_game = UseCase::StartNewGame.new(game_gateway)
evaluate_game = UseCase::EvaluateGame.new(game_gateway)
take_turn = UseCase::TakeTurn.new(game_gateway)

command_line_ui = CommandLineUI.new(
  start_new_game: start_new_game,
  evaluate_game: evaluate_game, 
  take_turn: take_turn
)

command_line_ui.execute()