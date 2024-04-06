# frozen_string_literal: true

require_relative '../lib/board'

CIRCLES = {
  'yellow' => "\e[33m\u25cf\e[0m",
  'blue' => "\e[34m\u25cf\e[0m",
  'empty' => "\u25cb"
}.freeze

describe Board do

  describe '#add_circle' do

    subject(:board) { described_class.new }
  
    context 'when circle cant be added' do
      it 'returns 0' do
        allow(board). to receive(:circle_cant_be_added?).and_return(true)
        response = board.add_circle(5, 'yellow')
        expect(response).to eq 0
      end
    end

    context 'when circle can be added' do
      it 'returns 1' do
        response = board.add_circle(5, 'yellow')
        expect(response).to eq 1
      end 

      context 'and when column is empty' do 
        it 'adds circle at the bottom' do
          board.add_circle(1, 'yellow')
          fields = board.instance_variable_get(:@fields)
          bottom = fields[5][0]
          expect(bottom).to eq CIRCLES['yellow']
        end
      end

      context 'and when column has circles' do 
        it 'adds circle above last circle in column' do
          board.add_circle(1, 'yellow')
          board.add_circle(1, 'blue')
          fields = board.instance_variable_get(:@fields)
          bottom = fields[4][0]
          expect(bottom).to eq CIRCLES['blue']
        end
      end
    end  
  end

  describe '#four_in_line?' do
    
    subject(:board) { described_class.new }
    let(:has_four) {
      [
        ["\u25cb", "\u25cb", "\u25cb", "\u25cb", "\u25cb", "\u25cb", "\e[33m\u25cf\e[0m"],
        ["\u25cb", "\u25cb", "\u25cb", "\u25cb", "\u25cb", "\u25cb", "\e[33m\u25cf\e[0m"],
        ["\u25cb", "\u25cb", "\u25cb", "\u25cb", "\u25cb", "\u25cb", "\e[33m\u25cf\e[0m"],
        ["\u25cb", "\u25cb", "\u25cb", "\u25cb", "\u25cb", "\u25cb", "\e[33m\u25cf\e[0m"],
        ["\u25cb", "\u25cb", "\u25cb", "\u25cb", "\u25cb", "\u25cb", "\u25cb"],
        ["\u25cb", "\u25cb", "\u25cb", "\u25cb", "\u25cb", "\u25cb", "\u25cb"],
      ]
    }
    let(:no_four) {
      [
        ["\u25cb", "\u25cb", "\u25cb", "\u25cb", "\e[33m\u25cf\e[0m", "\u25cb", "\u25cb"],
        ["\u25cb", "\u25cb", "\u25cb", "\u25cb", "\u25cb", "\u25cb", "\u25cb"],
        ["\u25cb", "\u25cb", "\u25cb", "\u25cb", "\u25cb", "\u25cb", "\u25cb"],
        ["\u25cb", "\u25cb", "\u25cb", "\u25cb", "\u25cb", "\u25cb", "\u25cb"],
        ["\u25cb", "\u25cb", "\u25cb", "\u25cb", "\u25cb", "\u25cb", "\u25cb"],
        ["\u25cb", "\u25cb", "\u25cb", "\u25cb", "\u25cb", "\u25cb", "\u25cb"]
      ]
    }
    let(:diagonal) {
      [
        ["\u25cb", "\u25cb", "\u25cb", "\u25cb", "\u25cb", "\u25cb", "\u25cb"],
        ["\u25cb", "\u25cb", "\e[33m\u25cf\e[0m", "\u25cb", "\u25cb", "\u25cb", "\u25cb"],
        ["\u25cb", "\u25cb", "\u25cb", "\e[33m\u25cf\e[0m", "\u25cb", "\u25cb", "\u25cb"],
        ["\u25cb", "\u25cb", "\u25cb", "\u25cb", "\e[33m\u25cf\e[0m", "\u25cb", "\u25cb"],
        ["\u25cb", "\u25cb", "\u25cb", "\u25cb", "\u25cb", "\e[33m\u25cf\e[0m", "\u25cb"],
        ["\u25cb", "\u25cb", "\u25cb", "\u25cb", "\u25cb", "\u25cb", "\u25cb"]
      ]
    }

    context 'when circle is invalid' do
      it 'returns false' do
        response = board.four_in_line?('brown')
        expect(response).to be false
      end
    end
    
    context 'when there are 4 circles in a line' do

      before do 
        board.instance_variable_set(:@fields, has_four)
        board.instance_variable_set(:@last_added, [2, 6])
      end

      it 'returns true' do
        response = board.four_in_line?('yellow')
        expect(response).to be true
      end
    end

    context 'when there are no 4 circles in a line' do

      before do 
        board.instance_variable_set(:@fields, no_four)
        board.instance_variable_set(:@last_added, [0, 4])
      end

      it 'returns false' do
        response = board.four_in_line?('yellow')
        expect(response).to be false
      end
    end

    context 'when there are 4 circles in a diagonal' do

      before do 
        board.instance_variable_set(:@fields, diagonal)
        board.instance_variable_set(:@last_added, [3, 4])
      end

      it 'returns true' do
        response = board.four_in_line?('yellow')
        expect(response).to be true
      end
    end
  end
end