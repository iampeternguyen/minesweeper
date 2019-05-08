require_relative 'tile'
require 'colorize'
class Board
  attr_reader :grid
  def initialize(size = [9,9])
    @width, @height = size
    @grid=Array.new(@height) {Array.new(@width) {Tile.new()}}
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
    surrounding_areas = [
      [-1,-1], [-1,0], [-1, 1],
      [ 0,-1],         [ 0, 1],
      [ 1,-1], [ 1,0], [ 1, 1]
      ]

    bombs = 0
    surrounding_areas.each do |delta|
      row_delta, col_delta = delta
      new_row = row + row_delta
      new_col = col + col_delta
      next unless valid_pos?(new_row, new_col)
      bombs += 1 if @grid[row+row_delta][col+col_delta].is_bomb?
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

  def render
    print "  "
    puts (0...@grid[0].length).to_a.join(" ").blue
    @grid.each_with_index do |row, index|
      print "#{index.to_s.blue} "
      row.each do |tile|
        if tile.hidden? && !tile.flagged?
          print "  ".colorize(:background => :white)
        else
          print "#{tile} ".red if tile.is_bomb?
          print "#{tile} " if !tile.is_bomb?
        end
      end
      print "\n"
    end
  end
end