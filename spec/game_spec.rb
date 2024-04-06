# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/player'
require_relative '../lib/board'


describe Game do

  describe '#game_setup' do
    subject(:game) { described_class.new }

    it 'creates two players' do
      allow(game).to receive(:get_name)
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
        allow(game.instance_variable_get(:@board)).to receive(:print_board)
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
        allow(game.instance_variable_get(:@board)).to receive(:print_board)
      end

      it 'displays error msg twice' do
        msg = 'Invalid input! Try again: '
        expect(game).to receive(:print).with(msg).twice
        game.play_round
      end
    end
  end
end