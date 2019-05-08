class Board
  attr_reader :grid
  def initialize(size = [9,9])
    width, height = size
    @grid=Array.new(height) {Array.new(width)}
  end
end