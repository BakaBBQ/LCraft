class StackView < Scene_MenuBase
  def start
    super
    @stack = ItemStack.new($game_party.leader.backpack, 10)
    create_renderers
  end
  
  def create_renderers
    @material_renderer = Ui_ItemMaterials.new(Graphics.width - 32*10 - 15, 0, @stack)
    @property_renderer = Ui_ItemProperties.new(@material_renderer.x,@material_renderer.height,@stack)
    @property_renderer.refresh
  end
end