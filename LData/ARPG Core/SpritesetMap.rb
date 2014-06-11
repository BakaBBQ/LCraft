Spriteset_Map = Class.new Spriteset_Map do
  #--------------------------------------------------------------------------
  # ● 生成人物精灵
  #--------------------------------------------------------------------------
  def create_characters
    super
#~     msgbox "meow"
    $game_map.projectiles.each do |event|
      @character_sprites.push(Sprite_Character.new(@viewport1, event))
    end
    
  end
end
