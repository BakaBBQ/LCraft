module Kernel
  def gw
    return Graphics.width
  end
  
  def gh
    return Graphics.height
  end
end


class BattlerStatus < Window_Base
  def initialize
    super(gw/2, 0, gw/2, gh)
  end
end