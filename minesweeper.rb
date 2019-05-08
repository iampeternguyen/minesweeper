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
    puts "[r]eveal tile or [f]lag bomb?"
    input = gets.chomp
    if input == 'r'
      reveal_pos
    elsif input == 'f'
      flag_bomb
    else
      return
    end
  end

  def flag_bomb
    pos = get_pos_input
    return if pos == nil
    row,col = pos
    @board.grid[row][col].flag_bomb if @board.valid_pos?(row,col)

  end

  def get_pos_input
    puts "select a tile (row,col). Eg. 2,3"
    begin
      pos = (gets.chomp.split(',').to_a.map{|ele| Integer(ele)})
      return pos if pos.length == 2
    rescue => exception
      puts "please use the correct format"
      return nil
    end
  end

  def reveal_pos
    pos = get_pos_input
    return if pos == nil
    row, col = pos
    @board.grid[row][col].show if @board.valid_pos?(row,col)
  end
end


game = MinesweeperGame.new
game.run