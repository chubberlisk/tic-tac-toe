# frozen_string_literal: true

describe UserInterface::Presenter do
  class CommandLineSpy
    attr_reader :display_turn_calls, :display_turn_arguments, :ask_user_for_position_calls, :display_game_over_arguments

    def initialize
      @ask_user_for_first_player_called = false
      @display_turn_calls = 0
      @display_turn_arguments = []
      @ask_user_for_position_calls = 0
      @display_game_over_called = false
    end

    def ask_user_for_first_player
      @ask_user_for_first_player_called = true

      :ask_user_for_first_player_response
    end

    def ask_user_for_first_player_called?
      @ask_user_for_first_player_called
    end

    def display_turn(response)
      @display_turn_calls += 1
      @display_turn_arguments << response
    end

    def ask_user_for_position
      @ask_user_for_position_calls += 1

      :ask_user_for_position_response
    end

    def display_game_over(response)
      @display_game_over_called = true
      @display_game_over_arguments = response
    end

    def display_game_over_called?
      @display_game_over_called
    end
  end

  class StartNewGameSpy
    attr_reader :execute_arguments

    def initialize
      @execute_called = false
    end

    def execute(game_options)
      @execute_called = true
      @execute_arguments = game_options

      :start_new_game_response
    end

    def execute_called?
      @execute_called
    end
  end

  class TakeTurnSpy
    attr_reader :execute_calls, :execute_arguments

    def initialize
      @execute_calls = 0
      @execute_arguments = []
    end

    def execute(turn_options)
      @execute_calls += 1
      @execute_arguments << turn_options

      :take_turn_response
    end
  end

  class EvaluateGameSpy
    attr_reader :execute_calls
    attr_writer :outcomes

    def initialize
      @execute_calls = 0
      @outcomes = []
    end

    def execute(*)
      outcome = @outcomes[@execute_calls]
      @execute_calls += 1

      { outcome: outcome }
    end
  end

  let(:command_line) { CommandLineSpy.new }
  let(:start_new_game) { StartNewGameSpy.new }
  let(:take_turn) { TakeTurnSpy.new }
  let(:evaluate_game) { EvaluateGameSpy.new }
  let(:ui_presenter) do
    UserInterface::Presenter.new(
      user_interface: command_line,
      start_new_game: start_new_game,
      take_turn: take_turn,
      evaluate_game: evaluate_game
    )
  end

  context 'when no turn is taken' do
    before { ui_presenter.execute({}) }

    it 'can ask the user for the first player' do
      expect(command_line.ask_user_for_first_player_called?).to eq(true)
    end

    it 'can start a new game' do
      expect(start_new_game.execute_called?).to eq(true)
      expect(start_new_game.execute_arguments).to eq(
        first_player: :ask_user_for_first_player_response
      )
    end

    it 'can display the first turn' do
      expect(command_line.display_turn_calls).to eq(1)
      expect(command_line.display_turn_arguments).to include(
        :start_new_game_response
      )
    end
  end

  context 'when only one turn is taken' do
    before do
      evaluate_game.outcomes = [:continue, nil]

      ui_presenter.execute({})
    end

    it 'can ask the user for a position' do
      expect(command_line.ask_user_for_position_calls).to eq(1)
    end

    it 'can take a turn' do
      expect(take_turn.execute_calls).to eq(1)
      expect(take_turn.execute_arguments).to contain_exactly(
        position: :ask_user_for_position_response
      )
    end

    it 'can display a turn' do
      expect(command_line.display_turn_calls).to eq(2)
      expect(command_line.display_turn_arguments).to contain_exactly(
        :start_new_game_response,
        :take_turn_response
      )
    end
  end

  context 'when multiple turns are taken while game has not ended' do
    before do
      evaluate_game.outcomes = [:continue, :continue, nil]

      ui_presenter.execute({})
    end

    it 'can ask the user for another position' do
      expect(command_line.ask_user_for_position_calls).to eq(2)
    end

    it 'can take another turn' do
      expect(take_turn.execute_calls).to eq(2)
      expect(take_turn.execute_arguments).to contain_exactly(
        { position: :ask_user_for_position_response },
        position: :ask_user_for_position_response
      )
    end

    it 'can display another turn' do
      expect(command_line.display_turn_calls).to eq(3)
      expect(command_line.display_turn_arguments).to contain_exactly(
        :start_new_game_response,
        :take_turn_response,
        :take_turn_response
      )
    end
  end

  context 'when game has ended after multiple turns' do
    before do
      evaluate_game.outcomes = [:continue, :continue, :continue, nil]

      ui_presenter.execute({})
    end

    it 'can evaluate the final result of the game' do
      expect(evaluate_game.execute_calls).to eq(5)
    end

    it 'can display game over' do
      expect(command_line.display_game_over_called?).to eq(true)
      expect(command_line.display_game_over_arguments).to eq(outcome: nil)
    end
  end
end
