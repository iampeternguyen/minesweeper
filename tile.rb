require 'colorize'
class Tile
  def initialize(value = " ")
    @value = value
    @hidden = true
    @flagged = false
  end

  def is_bomb?
    @value == "b"
  end

  def is_blank?
    @value == " "
  end

  def flag_bomb
    @flagged = true if @hidden
  end

  def hidden?
    @hidden
  end

  def flagged?
    @flagged
  end

  def to_s
    if @flagged
      "*"
    elsif @hidden
      " "
    else
      @value.to_s
    end
  end

  def show
    @hidden = false
    @flagged = false
  end

  def value(val)
    @value = val
  end
end