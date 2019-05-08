require_relative 'board'

class MinesweeperGame
  def initialize
    @board = Board.new([9,9])
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
    puts "move cursor using [w] [s] [a] [d]. [r]eveal tile or [f]lag bomb?"

    input = gets.chomp
    case input
    when 'r'
      reveal_pos
    when 'f'
      flag_bomb
    when 'w'
      @board.cursor_row -= 1 if (@board.cursor_row - 1).between?(0,@board.height-1)
    when 's'
      @board.cursor_row += 1 if (@board.cursor_row + 1).between?(0,@board.height-1)
    when 'a'
      @board.cursor_col -= 1 if (@board.cursor_col - 1).between?(0,@board.width-1)
    when 'd'
      @board.cursor_col += 1 if (@board.cursor_col + 1).between?(0,@board.width-1)
    end

  end


  def flag_bomb
    @board.flag_bomb
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
    @board.reveal(@board.cursor_row, @board.cursor_col)
  end
end


game = MinesweeperGame.new
game.run