# frozen_string_literal: true

require_relative 'board'
require_relative 'player'

# Game logic
class Game

  def initialize
    @player_one = nil
    @player_two = nil
    @current_player = nil
    @board = Board.new
    @player_rounds = 0
    @tie = false
  end

  def start
    game_setup
    play_round until game_over?
  end

  def game_setup
    puts 'Welcome to Connect Four Game!'
    name = get_name
    @player_one = Player.new(name, 'yellow')
    name = get_name
    @player_two = Player.new(name, 'blue')
    @current_player = @player_one
  end

  def get_name
    print 'Input player name [max 12 characters]: '
    name = nil
    loop do
      name = gets.chomp
      break if name.length > 0 && name.length <= 12
      print 'Invalid name! Try again: '
    end
    name
  end

  def play_round
    @board.print_board
    puts "#{@current_player.name} is playing!"
    print 'Insert column: '
    loop do
      column = gets.chomp.to_i # convert input to integer so it is easier to check
      response = @board.add_circle(column, 'yellow')
      break if response == 1

      print 'Invalid input! Try again: '
    end
  end
end