describe UserInterface::Presenter do
  class UserInterfaceFoo
    attr_reader :display_turn_arguments

    def initialize
      @ask_user_for_first_player_called = false
      @display_turn_called = false
    end

    def ask_user_for_first_player
      @ask_user_for_first_player_called = true
      :player_x
    end

    def ask_user_for_first_player_called?
      @ask_user_for_first_player_called
    end

    def display_turn(response)
      @display_turn_called = true
      @display_turn_arguments = response
    end

    def display_turn_called?
      @display_turn_called
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
      {
        grid: [],
        player_turn: nil
      }
    end

    def execute_called?
      @execute_called
    end
  end

  let(:user_interface) { UserInterfaceFoo.new }
  let(:start_new_game) { StartNewGameFoo.new }
  let(:ui_presenter) do
    UserInterface::Presenter.new(
      start_new_game: start_new_game,
      evaluate_game: nil,
      take_turn: nil,
      user_interface: user_interface
    )
  end

  it 'can get the first player from user' do
    ui_presenter.execute({})

    expect(user_interface.ask_user_for_first_player_called?).to eq(true)
  end

  it 'can start a new game' do
    ui_presenter.execute({})

    expect(start_new_game.execute_called?).to eq(true)
    expect(start_new_game.execute_arguments).to eq(first_player: :player_x)
  end

  it 'can display the first turn' do
    ui_presenter.execute({})

    expect(user_interface.display_turn_called?).to eq(true)
    expect(user_interface.display_turn_arguments).to eq(
      grid: [],
      player_turn: nil
    )
  end
end
