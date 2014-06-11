Sprite_Character = Class.new Sprite_Character.clone do
  def update
    super
    update_size_for_battler if self.character.respond_to?(:battler)
  end
  
  def update_size_for_battler
    self.zoom_x = self.zoom_y = self.character.battler.body.main_size / 65.0
  end
  
end
