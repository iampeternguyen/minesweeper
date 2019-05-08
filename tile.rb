class Tile
  def initialize(value = " ")
    @value = value
    @reveal = false
  end

  def is_bomb?
    @value == "b"
  end

  def to_s
    @reveal ? @value.to_s : " "
  end

  def value(val)
    @value = val
  end
end