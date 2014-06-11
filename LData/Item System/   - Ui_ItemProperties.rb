class Ui_ItemProperties < Window_Base
  def initialize(x,y,itemstack)
    super(x,y,32*10 + 15,Graphics.height - 45)
    @item = itemstack.item
  end
  
  def refresh
    self.contents.clear
    cursor.reset
    load_view 'itemStatus'
  end
end
