describe UI::Presenter do
  class StartNewGameSpy
    def initialize
      @called = false
    end

    def called?
      @called
    end

    def execute(*)
      @called = true
    end
  end

  class EvaluateGameStub
    attr_writer :stop_calls_after
    attr_reader :number_of_calls

    def initialize
      @number_of_calls = 0
      @stop_calls_after = 0
    end

    def execute(*)
      @number_of_calls += 1

      if @number_of_calls > @stop_calls_after
        { outcome: nil }
      else
        { outcome: :continue }
      end
    end
  end

  class TakeTurnStub
    def initialize
      @called = false
    end

    def called?
      @called
    end

    def execute(*)
      @called = true
    end
  end

  class UserInterfaceFake
    attr_reader :display_game_screen_called

    def initialize
      @display_game_screen_called = 0
    end

    def ask_user_for_first_player
      :player_x
    end

    def ask_user_for_position
    end

    def display_game_screen(*)
      @display_game_screen_called += 1
    end

    def display_end_screen(*)
    end
  end

  let(:start_new_game_spy) { StartNewGameSpy.new }
  let(:evaluate_game_stub) { EvaluateGameStub.new }
  let(:take_turn_stub) { TakeTurnStub.new }
  let(:user_interface_fake) { UserInterfaceFake.new }
  let(:presenter) do
    UI::Presenter.new(
      start_new_game: start_new_game_spy,
      evaluate_game: evaluate_game_stub,
      take_turn: take_turn_stub,
      user_interface: user_interface_fake
    )
  end

  it 'can start a new game' do
    presenter.execute

    expect(start_new_game_spy.called?).to eq(true)
  end

  it 'can display the new game' do
    presenter.execute

    expect(user_interface_fake.display_game_screen_called).to eq(1)
  end

  it 'can take a turn' do
    evaluate_game_stub.stop_calls_after = 1

    presenter.execute

    expect(take_turn_stub.called?).to eq(true)
  end

  it 'can display the turn' do
    evaluate_game_stub.stop_calls_after = 1

    presenter.execute

    expect(user_interface_fake.display_game_screen_called).to eq(2)
  end

  it 'can end the game' do
    evaluate_game_stub.stop_calls_after = 1

    presenter.execute

    expect(evaluate_game_stub.number_of_calls).to eq(3)
  end
end
