class Board
  attr_reader :grid
  def initialize(size = [9,9])
    @width, @height = size
    @grid=Array.new(@height) {Array.new(@width, " ")}
    populate_bombs(size)

  end

  def populate_bombs(size)
    spaces = @width * @height
    number_of_bombs = spaces / 2
    while number_of_bombs > 0
      col,row = rand(@width), rand(@height)
      if @grid[row][col] == " "
        @grid[row][col] = "b"
        number_of_bombs -= 1
      end
    end
  end

  def render
    print "  "
    puts (0...@grid[0].length).to_a.join(" ")
    @grid.each_with_index do |row, index|
      puts "#{index} #{row.join(" ")}"
    end
  end
end