Spriteset_Map = Class.new Spriteset_Map.clone do
  def create_pictures
    super
    @itemstack_vp = Viewport.new(0,0,Graphics.width,Graphics.height)
    @itemstack_vp.z = 0
    @stack_sprites =  Array.new($game_map.width){Array.new($game_map.height){[]}}
    init_itemstack_sprites
  end
  
  def itemstacks
    return $game_map.itemstacks
  end
  
  def refresh_itemstacks
    for i in 0...$game_map.width
      for j in 0...$game_map.height
        @stack_sprites[i][j].each do |sp|
          sp.refresh
        end
      end
    end
  end
  
  def redraw_itemstack_sprite(a,b)
    @stack_sprites[a][b].each do |sp|
      sp.bitmap.clear
    end
    i = a
    j = b
    itemstacks[i][j].each do |a|
          @stack_sprites[i][j] <<  Sprite_ItemStack.new(@viewport1) do |sp|
            sp.itemstack = a
          end
        end
  end
  
  def init_itemstack_sprites
   
    for i in 0...$game_map.width
      for j in 0...$game_map.height
#~          itemstacks[i][j] = itemstacks[i][j].compact
        @stack_sprites[i][j] = []
        itemstacks[i][j].each do |a|
          @stack_sprites[i][j] <<  Sprite_ItemStack.new(@viewport1) do |sp|
            sp.itemstack = a
          end
        end
      end
    end
  end # def
  
  def update
    super
    update_itemstack_positions
  end
  
  
  def update_itemstack_positions
     for i in 0...$game_map.width
      for j in 0...$game_map.height
        @stack_sprites[i][j].each do |sp|
          sp.x = i * 32
          sp.y = j * 32
          sp.ox = $game_map.display_x * 32 - 6
          sp.oy = $game_map.display_y * 32 - 6
          sp.z = 0
        end
      end
    end
  end
end
