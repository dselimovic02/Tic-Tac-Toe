# frozen_string_literal: true

# frozen_string_litreal: true

# Game playing field
class Board
  attr_accessor :fields

  def initialize
    @fields = Array.new(6) { Array.new(7) }
  end
end
