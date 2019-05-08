require_relative 'tile'
require 'colorize'
class Board
  attr_accessor :cursor_col, :cursor_row
  attr_reader :grid, :width, :height
  def initialize(size = [9,9])
    @width, @height = size
    @grid=Array.new(@height) {Array.new(@width) {Tile.new()}}
    @surrounding_areas = [
      [-1,-1], [-1,0], [-1, 1],
      [ 0,-1],         [ 0, 1],
      [ 1,-1], [ 1,0], [ 1, 1]
      ]

    @cursor_row = 0
    @cursor_col = 0

    populate_bombs(size)
    populate_bomb_indicators
  end



  def populate_bomb_indicators

    (0...@width).each do |col|
      (0...@height).each do |row|
        next if @grid[row][col].is_bomb?
        @grid[row][col].value(calculate_bombs(row,col))
      end
    end

  end

  def calculate_bombs(row, col)
    bombs = 0
    @surrounding_areas.each do |delta|
      row_delta, col_delta = delta
      new_row = row + row_delta
      new_col = col + col_delta
      next unless valid_pos?(new_row, new_col)
      bombs += 1 if @grid[new_row][new_col].is_bomb?
    end
    bombs == 0 ? " " : bombs
  end

  def valid_pos?(row, col)
    row.between?(0, @height-1) && col.between?(0,@width-1)
  end

  def populate_bombs(size)
    spaces = @width * @height
    number_of_bombs = spaces / 10
    while number_of_bombs > 0
      col,row = rand(@width), rand(@height)
      if !@grid[row][col].is_bomb?
        @grid[row][col].value("b")
        number_of_bombs -= 1
      end
    end
  end


  def flag_bomb
    @grid[@cursor_row][@cursor_col].flag_bomb
  end

  def reveal(row,col)
    @grid[row][col].show
    if @grid[row][col].is_blank?
      @surrounding_areas.each do |delta|
        row_delta, col_delta = delta
        new_row = row + row_delta
        new_col = col + col_delta
        next unless valid_pos?(new_row, new_col)

        if @grid[new_row][new_col].is_blank? && @grid[new_row][new_col].hidden?
          reveal(new_row, new_col)
        end

        @grid[new_row][new_col].show unless @grid[new_row][new_col].is_bomb?

      end
    end
  end

  def flag_bomb
    @grid[@cursor_row][@cursor_col].flag_bomb
  end

  def render
    print "  "
    puts (0...@grid[0].length).to_a.join(" ").blue
    @grid.each_with_index do |row, row_index|
      print "#{row_index.to_s.blue} "
      row.each_with_index do |tile, col_index|
        if tile.hidden? && !tile.flagged?
          if row_index == @cursor_row && col_index == @cursor_col
            print "  ".colorize(:background => :green)
          else
            print "  ".colorize(:background => :white)
          end
        elsif tile.hidden? && tile.flagged?
          if row_index == @cursor_row && col_index == @cursor_col
            print "* ".colorize(:background => :green)
          else
            print "  ".colorize(:background => :yellow)
          end
        else
          if row_index == @cursor_row && col_index == @cursor_col
            print "#{tile} ".colorize(:background => :green) if !tile.is_bomb?
          else
            print "#{tile} ".red if tile.is_bomb? && !tile.hidden?
            print "#{tile} " if !tile.is_bomb?
          end

        end
      end
      print "\n"
    end
  end
end