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
      def execute(*)
        {outcome: nil}
      end

    end

    class TakeTurnStub

    end

    class UserInterfaceFake
      def initialize
        @display_game_screen_called = false
      end

      def ask_user_for_first_player
        :player_x
      end

      def display_game_screen(*)
        @display_game_screen_called = true
      end

      def display_game_screen_called?
        @display_game_screen_called
      end

      def display_end_screen(*)

      end
    end


  it 'can start a new game' do
    start_new_game_spy = StartNewGameSpy.new
    evaluate_game_stub = EvaluateGameStub.new
    take_turn_stub = TakeTurnStub.new
    user_interface_fake = UserInterfaceFake.new

    presenter = UI::Presenter.new(
      start_new_game: start_new_game_spy,
      evaluate_game: evaluate_game_stub, 
      take_turn: take_turn_stub, 
      user_interface: user_interface_fake
      )
      presenter.execute

      expect(start_new_game_spy.called?).to eq(true)
  end

  it 'can display the new game' do
    start_new_game_spy = StartNewGameSpy.new
    evaluate_game_stub = EvaluateGameStub.new
    take_turn_stub = TakeTurnStub.new
    user_interface_fake = UserInterfaceFake.new

    presenter = UI::Presenter.new(
      start_new_game: start_new_game_spy,
      evaluate_game: evaluate_game_stub, 
      take_turn: take_turn_stub, 
      user_interface: user_interface_fake
      )
      presenter.execute

      expect(user_interface_fake.display_game_screen_called?).to eq(true)
  end


end