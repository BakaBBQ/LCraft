class PartView < Window_Base
  attr_accessor :part
  def initialize(x,y, part)
    rect = Rect.new(x,y,Graphics.width - x, Graphics.height - y)
    @part = part
    super(rect.x,rect.y,rect.width,rect.height)
  end
  
  def refresh
    self.contents.clear
    cursor.reset
    load_file("./Views/partView.rmd")
  end
end