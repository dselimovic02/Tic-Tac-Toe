# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/player'
require_relative '../lib/board'


describe Game do

  describe '#game_setup' do
    subject(:game) { described_class.new }

    it 'creates two players' do
      allow(game).to receive(:get_name)
      allow(game).to receive(:puts)
      game.game_setup
      player_one = game.instance_variable_get(:@player_one)
      player_two = game.instance_variable_get(:@player_two)
      expect(player_one.is_a?(Player)).to be true
      expect(player_two.is_a?(Player)).to be true 
    end
  end

  describe '#get_name' do

    subject(:game) { described_class.new }

    context 'when user inputs valid name' do
      before do
        valid_name = 'Player'
        allow(game).to receive(:gets).and_return(valid_name)
        allow(game).to receive(:print)
      end

      it 'does not raise an error' do
        error_msg = 'Invalid name! Try again: '
        expect(game).not_to receive(:print).with(error_msg)
        game.get_name
      end
    end

    context 'when user inputs invalid name and then a valid name' do
      before do
        valid_name = 'Player'
        invalid_name = ''
        allow(game).to receive(:gets).and_return(invalid_name, valid_name)
        allow(game).to receive(:print)

      end

      it 'it raises an error once' do
        error_msg = 'Invalid name! Try again: '
        expect(game).to receive(:print).with(error_msg).once
        game.get_name
      end
    end

    it 'returns inputed name' do
      allow(game).to receive(:gets).and_return('Name')
      allow(game).to receive(:print)
      name = game.get_name
      expect(name).to eq 'Name'
    end
  end

  describe '#play_round' do
    context 'when player inputs a column' do
      
      subject(:game) { described_class.new }
      let(:player) { double('player', name: 'Player', color: 'yellow' ) }
      let(:board) { instance_double(Board) }
      
      before do
        game.instance_variable_set(:@current_player, player)
        game.instance_variable_set(:@board, board)
        allow(game).to receive(:gets).and_return('5')
        allow(board).to receive(:add_circle).and_return(1)
        allow(board).to receive(:print_board)
        allow(game).to receive(:print)
        allow(game).to receive(:puts)
        allow(game).to receive(:game_over?).and_return(false)
      end

      it 'sends add_circle command to board' do
        expect(board).to receive(:add_circle).with(5, player.color)
        game.play_round
      end
    end

    context 'if add_circle response is 0' do
      
      subject(:game) { described_class.new }
      let(:player) { double('player', name: 'Player', color: 'yellow' ) }
      
      before do
        game.instance_variable_set(:@current_player, player)
        allow(game).to receive(:gets).and_return('12', '3')
        allow(game).to receive(:print)
        allow(game).to receive(:puts)
        allow(game.instance_variable_get(:@board)).to receive(:print_board)
        allow(game).to receive(:game_over?).and_return(false)
      end

      it 'displays error msg once' do
        msg = 'Invalid input! Try again: '
        expect(game).to receive(:print).with(msg).once
        game.play_round
      end
    end

    context 'if add_circle response is 0 two times' do
      
      subject(:game) { described_class.new }
      let(:player) { double('player', name: 'Player', color: 'yellow' ) }
      
      before do
        game.instance_variable_set(:@current_player, player)
        allow(game).to receive(:gets).and_return('12', 'dog', '3')
        allow(game).to receive(:print)
        allow(game).to receive(:puts)
        allow(game.instance_variable_get(:@board)).to receive(:print_board)
        allow(game).to receive(:game_over?).and_return(false)
      end

      it 'displays error msg twice' do
        msg = 'Invalid input! Try again: '
        expect(game).to receive(:print).with(msg).twice
        game.play_round
      end
    end

    context 'when it is game over' do
      subject(:game_over) { described_class.new }
      let(:player) { double('player', name: 'Player', color: 'yellow' ) }

      before do 
        game_over.instance_variable_set(:@current_player, player)
        allow(game_over).to receive(:gets).and_return('5')
        allow(game_over).to receive(:puts)
        allow(game_over).to receive(:print)
        allow(game_over.instance_variable_get(:@board)).to receive(:print_board)
        allow(game_over).to receive(:game_over?).and_return(true)
      end

      it 'changes @end_state to true' do
        game_over.play_round
        end_game = game_over.instance_variable_get(:@end_game)
        expect(end_game).to be true
      end
    end
  end

  describe '#swap_current_player' do

    subject(:game)  { described_class.new }
    let(:player_one) { instance_double(Player) }
    let(:player_two) { instance_double(Player) }

    before do
      game.instance_variable_set(:@player_one, player_one)
      game.instance_variable_set(:@player_two, player_two)
    end

    context 'if current player is player one' do
      before do
        game.instance_variable_set(:@current_player, player_one)
      end

      it 'swaps it to player two' do
        game.swap_current_player
        current_player = game.instance_variable_get(:@current_player)
        expect(current_player).to be player_two
      end
    end

    context 'if current player is player two' do
      before do
        game.instance_variable_set(:@current_player, player_two)
      end

      it 'swaps it to player one' do
        game.swap_current_player
        current_player = game.instance_variable_get(:@current_player)
        expect(current_player).to be player_one
      end
    end
  end

  describe 'game_over?' do

    subject(:game) { described_class.new }
    let(:board) { instance_double(Board) }
    let(:player) { instance_double(Player) }

    before do
      game.instance_variable_set(:@board, board)
      game.instance_variable_set(:@current_player, player)
      allow(player).to receive(:color)
    end

    context 'when player has connected four' do
      before do
        allow(board).to receive(:four_in_line?).and_return(true)
      end
      it 'sets that player as winner' do
        game.game_over?
        winner = game.instance_variable_get(:@winner)
        expect(winner).to be player
      end
      it 'returns true' do
        result = game.game_over?
        expect(result).to be true
      end
    end

    context 'when board is full' do
      before do
        allow(board).to receive(:four_in_line?).and_return(false)
        allow(board).to receive(:is_board_full?).and_return(true)
      end
      it 'returns true' do
        response = game.game_over?
        expect(response).to be true
      end
    end

    context 'when neither of conditions is met' do
      before do
        allow(board).to receive(:four_in_line?).and_return(false)
        allow(board).to receive(:is_board_full?).and_return(false)
      end
      it 'returns false' do
        response = game.game_over?
        expect(response).to be false
      end
    end
  end
end