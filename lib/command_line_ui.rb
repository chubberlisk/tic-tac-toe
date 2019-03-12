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

game_gateway = GameGateway.new
start_new_game = UseCase::StartNewGame.new(game_gateway)
evaluate_game = UseCase::EvaluateGame.new(game_gateway)
take_turn = UseCase::TakeTurn.new(game_gateway)

CLI::UI::StdoutRouter.enable

CLI::UI::Frame.open('Tic Tac Toe') do
  first_player = CLI::UI::Prompt.ask('Which player should go first?') do |handler|
    handler.option('Player X') { :player_x }
    handler.option('Player O') { :player_o }
  end

  game_options = { first_player: first_player }
  start_new_game_response = start_new_game.execute(game_options)

  first_player = start_new_game_response[:player_turn] == :player_x ? 'Player X' : 'Player O'

  CLI::UI::Frame.divider("#{first_player} Turn")
  puts create_terminal_table(start_new_game_response[:grid])
  puts

  while evaluate_game.execute({})[:outcome] == :continue
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

    turn_options = { position: position }
    take_turn_response = take_turn.execute(turn_options)

    player = take_turn_response[:player_turn] == :player_x ? 'Player X' : 'Player O'

    CLI::UI::Frame.divider("#{player} Turn")

    puts create_terminal_table(take_turn_response[:grid])
    puts
    puts CLI::UI.fmt "{{x}} {{red:#{take_turn_response[:error]}}}\n" if take_turn_response[:error]
  end

  CLI::UI::Frame.divider('Game Over')

  evaluate_game_response = evaluate_game.execute({})
  if evaluate_game_response[:outcome] == :player_x_win
    puts CLI::UI.fmt "{{green:Player X wins!}}"
  elsif evaluate_game_response[:outcome] == :player_o_win
    puts CLI::UI.fmt "{{green:Player O wins!}}"
  else
    puts CLI::UI.fmt "{{red:It's a draw!}}"
  end
end
