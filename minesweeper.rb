require_relative 'board'

class MinesweeperGame
  def initialize
    @board = Board.new
  end

  def run
    while true
      @board.render
      take_turn
    end
  end

  def take_turn
    puts "select a tile (row,col). Eg. 2,3"
    pos = (gets.chomp.split(',').to_a.map(&:to_i))
    row, col = pos
    @board.grid[row][col].show
  end
end


game = MinesweeperGame.new
game.run