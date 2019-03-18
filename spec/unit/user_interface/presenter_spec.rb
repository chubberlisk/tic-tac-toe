describe UserInterface::Presenter do
  class CommandLineFoo
    attr_reader :display_turn_calls, :display_turn_arguments

    def initialize
      @ask_user_for_first_player_called = false
      @display_turn_calls = 0
      @display_turn_arguments = []
      @ask_user_for_position_called = false
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

    def display_turn_called?
      @display_turn_called
    end

    def ask_user_for_position
      @ask_user_for_position_called = true

      :ask_user_for_position_response
    end

    def ask_user_for_position_called?
      @ask_user_for_position_called
    end
  end

  class StartNewGameFoo
    attr_reader :execute_arguments

    def initialize
      @execute_called = false
      @execute_arguments = nil
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

  class TakeTurnFoo
    attr_reader :execute_arguments

    def initialize
      @execute_called = false
      @execute_arguments = nil
    end

    def execute(turn_options)
      @execute_called = true
      @execute_arguments = turn_options

      :take_turn_response
    end

    def execute_called?
      @execute_called
    end
  end

  let(:command_line) { CommandLineFoo.new }
  let(:start_new_game) { StartNewGameFoo.new }
  let(:take_turn) { TakeTurnFoo.new }
  let(:ui_presenter) do
    UserInterface::Presenter.new(
      start_new_game: start_new_game,
      take_turn: take_turn,
      evaluate_game: nil,
      user_interface: command_line
    )
  end

  it 'can ask the user for the first player' do
    ui_presenter.execute({})

    expect(command_line.ask_user_for_first_player_called?).to eq(true)
  end

  it 'can start a new game' do
    ui_presenter.execute({})

    expect(start_new_game.execute_called?).to eq(true)
    expect(start_new_game.execute_arguments).to eq(
      first_player: :ask_user_for_first_player_response
    )
  end

  it 'can display the first turn' do
    ui_presenter.execute({})

    expect(command_line.display_turn_calls).to be >= 1
    expect(command_line.display_turn_arguments[0]).to eq(
      :start_new_game_response
    )
  end

  it 'can ask the user for a position' do
    ui_presenter.execute({})

    expect(command_line.ask_user_for_position_called?).to eq(true)
  end

  it 'can take a turn' do
    ui_presenter.execute({})

    expect(take_turn.execute_called?).to eq(true)
    expect(take_turn.execute_arguments).to eq(
      position: :ask_user_for_position_response
    )
  end

  it 'can display another turn' do
    ui_presenter.execute({})

    expect(command_line.display_turn_calls).to eq(2)
    expect(command_line.display_turn_arguments[1]).to eq(:take_turn_response)
  end
end
