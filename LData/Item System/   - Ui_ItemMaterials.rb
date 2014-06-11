class Ui_ItemMaterials < Window_Base
  def initialize(x,y, item)
    super(x,y,32*10 + 15, 45)
    @item = item.item
    refresh
  end
  
  def refresh
    self.contents.clear
    icons = @item.materials.collect{|m| m.icon_index}
    icons.each_with_index do |icon, index|
      draw_icon icon, index * 32,0
    end
  end
  
end