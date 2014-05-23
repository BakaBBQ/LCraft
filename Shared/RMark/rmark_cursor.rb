class RMark::Cursor
  attr_accessor :x, :y
  def initialize
    reset
  end
  
  def reset
	@x, @y = 0, 0
  end
end