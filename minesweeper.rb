require_relative 'board'

class MinesweeperGame
  def initialize
    @board = Board.new([2,2])
    @game_over = false
  end

  def run
    @board.render

    while !@game_over
      take_turn
      @board.render
      game_over?
    end
    game_won?
  end

  def game_over?
    tiles = @board.grid.flatten
    revealed_tiles = tiles.select {|tile| !tile.hidden?}
    not_bomb_tiles = tiles.select {|tile| !tile.is_bomb?}

    if revealed_tiles.any? {|tile| tile.is_bomb?} || not_bomb_tiles.all? {|tile| !tile.hidden?}
      @game_over = true
    end
  end

  def game_won?
    if @board.grid.flatten.any? {|tile| tile.is_bomb? && !tile.hidden?}
      puts "game over"
    else
      puts "you win"
    end
  end

  def take_turn
    puts "select a tile (row,col). Eg. 2,3"
    begin
      pos = (gets.chomp.split(',').to_a.map{|ele| Integer(ele)})
      p pos
    rescue => exception
      puts "please use the correct format"
      return
    end

    if pos.length == 2
      row, col = pos
      @board.grid[row][col].show if @board.valid_pos?(row,col)
    else
      take_turn
    end


  end
end


game = MinesweeperGame.new
game.run