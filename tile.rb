require 'colorize'
class Tile
  def initialize(value = " ")
    @value = value
    @hidden = true
  end

  def is_bomb?
    @value == "b"
  end

  def hidden?
    @hidden
  end

  def to_s
    @hidden ? " " : @value.to_s
  end

  def show
    @hidden = false
  end

  def value(val)
    @value = val
  end
end