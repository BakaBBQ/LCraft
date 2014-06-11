Sprite_Character = Class.new Sprite_Character.clone do
  #--------------------------------------------------------------------------
  # ● 更新源矩形
  #--------------------------------------------------------------------------
  def update_src_rect
     if character.respond_to?(:setup_page_settings) && character.character_name.include?("[dia]")
       self.ox = self.bitmap.width / 2
       self.oy = self.bitmap.height / 2
       self.angle = 180 - character.angle
       self.mirror = true
      return    
    end
    super
  end
  
  
  ANGLE_TABLE = {
    6 => 0,
    9 => 45,
    8 => 90,
    7 => 135,
    4 => 180,
    1 => 225,
    2 => 270,
    3 => 315,
  }
end
