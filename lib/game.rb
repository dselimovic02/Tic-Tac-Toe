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
    @end_game = false
    @winner = nil
  end

  def start
    game_setup
    play_round until @end_game
    end_game
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
    print "\e[2J\e[H"
    puts "#{@current_player.name} is playing!"
    @board.print_board
    print 'Insert column: '
    loop do
      column = gets.chomp.to_i # convert input to integer so it is easier to check
      response = @board.add_circle(column, @current_player.color)
      break if response == 1

      print 'Invalid input! Try again: '
    end
    @end_game = game_over?
    swap_current_player
  end

  def swap_current_player
    @current_player = @current_player == @player_one ? @player_two : @player_one
  end
  
  def game_over?
    if @board.four_in_line?(@current_player.color)
      @winner = @current_player
      return true
    elsif @board.is_board_full?
      return true
    else
      return false
    end
  end

  def end_game
    print "\e[2J\e[H"
    @board.print_board
    if @end_game
      puts "#{@winner.name} won the game!"
    else
      puts 'It\'s a tie!'
    end
  end
end