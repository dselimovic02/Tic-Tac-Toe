# frozen_string_literal: true

# Game Player
class Player
  attr_accessor :name, :color

  def initialize(name, color)
    @name = name
    @color = color
  end
end
