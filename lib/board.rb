# frozen_string_literal: true

# frozen_string_litreal: true

# Game playing field
class Board
  attr_reader :fields

  CIRCLES = {
    'yellow' => "\e[33m\u25cf\e[0m",
    'blue' => "\e[34m\u25cf\e[0m",
    'empty' => "\u25cb"
  }.freeze

  # [0,0] would be position of a circle, other positions are circles relative to [0,0]
  # These combinations will be used to check if 4 circles are in line
  COMBOS = [
    [ # Vertical combos    
      [[-3, 0], [-2, 0], [-1, 0], [0, 0]],
      [[-2, 0], [-1, 0], [0, 0], [1, 0]],
      [[-1, 0], [0, 0], [1, 0], [2, 0]],
      [[0, 0], [1, 0], [2, 0], [3, 0]]
    ],
    [ # Horizontal combos
      [[0, -3], [0, -2], [0, -1], [0, 0]],
      [[0, -2], [0, -1], [0, 0], [0, 1]],
      [[0, 1], [0, 0], [0, 1], [0, 2]],
      [[0, 0], [0, 1], [0, 2], [0, 3]]
    ],
    [ # Top left to bottom right diagonal
      [[-3, -3], [-2, -2], [-1, -1], [0, 0]],
      [[-2, -2], [-1, -1], [0, 0], [1, 1]],
      [[-1, -1], [0, 0], [1, 1], [2, 2]],
      [[0, 0], [1, 1], [2, 0], [3, 3]]
    ],
    [ # Bottom left to top right diagonal
      [[3, -3], [2, -2], [1, -1], [0, 0]],
      [[2, -2], [1, -1], [0, 0], [-1, 1]],
      [[1, -1], [0, 0], [-1, 1], [-2, 2]],
      [[0, 0], [-1, 1], [-2, 0], [-3, 3]]
    ]
  ].freeze

  def initialize
    @fields = Array.new(6) { Array.new(7, CIRCLES['empty']) }
    @last_added = []
  end

  def print_board
    puts <<-HEREDOC
      1 2 3 4 5 6 7
      #{@fields[0][0]} #{@fields[0][1]} #{@fields[0][2]} #{@fields[0][3]} #{@fields[0][4]} #{@fields[0][5]} #{@fields[0][6]}
      #{@fields[1][0]} #{@fields[1][1]} #{@fields[1][2]} #{@fields[1][3]} #{@fields[1][4]} #{@fields[1][5]} #{@fields[1][6]}
      #{@fields[2][0]} #{@fields[2][1]} #{@fields[2][2]} #{@fields[2][3]} #{@fields[2][4]} #{@fields[2][5]} #{@fields[2][6]}
      #{@fields[3][0]} #{@fields[3][1]} #{@fields[3][2]} #{@fields[3][3]} #{@fields[3][4]} #{@fields[3][5]} #{@fields[3][6]}
      #{@fields[4][0]} #{@fields[4][1]} #{@fields[4][2]} #{@fields[4][3]} #{@fields[4][4]} #{@fields[4][5]} #{@fields[4][6]}
      #{@fields[5][0]} #{@fields[5][1]} #{@fields[5][2]} #{@fields[5][3]} #{@fields[5][4]} #{@fields[5][5]} #{@fields[5][6]}
    HEREDOC
  end

  def add_circle(column, circle)
    column = column - 1 # User inputs columns from 1-7, therefore subtract one from input

    # return 0 if circle was not added (conditions that it can be added are not met)
    return 0 if circle_cant_be_added?(column, circle)

    # add circle to column
    5.downto(0) do |row|
       if @fields[row][column] == CIRCLES['empty']
        @fields[row][column] = CIRCLES[circle]
        # save position so we have relative position to check if four are connected
        @last_added = []
        @last_added << row
        @last_added << column
        break 
      end
    end 

    # return 1 when circle is added sucessfully 
    return 1
  end

  def four_in_line?(circle)
    return false if invalid_circle?(circle)
    
    COMBOS.each do |direction|
      direction.each do |set|
        # each set holds 4 positions that connect four circles
        # if each field position, calculated from our last added circle, has that circle
        # it means four are connected
        return true if set.all? do |position| 
          # calculate coords and skip iteration if coors go out of bounds
          x = @last_added[0]+position[0]
          next if x > 5 || x < 0
          y = @last_added[1]+position[1]
          next if y > 6 || y < 0
          value =  @fields[x][y]
          value == CIRCLES[circle] 
        end
      end
    end

    false
  end

  def is_board_full?
    @fields.all? do |row|
      row.all? { |circle| circle != CIRCLES['empty'] }
    end
  end

  private 
  
  def circle_cant_be_added?(column, circle)
    invalid_column?(column) || invalid_circle?(circle) || column_full?(column)
  end

  def column_full?(column_num) 
    @fields[0][column_num] != CIRCLES['empty']
  end

  def invalid_column?(column)
    # all string inputs get converted to 0, hence we also disable string inputs with these conditions
    column < 0 || column > 6
  end

  def invalid_circle?(circle)
  circle != 'yellow' && circle != 'blue'
  end
end


