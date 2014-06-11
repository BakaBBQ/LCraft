=begin
designates Game_Event and Game_Player being different
the event battler is read thru the event's name
while player battler is read to the game_party's leader
=end
  
  
=begin
this script only adds the spaces for the battlers to be
=end



Game_Character = Class.new Game_Character do
  attr_accessor :battler
  def init_public_members
    super
    @battler = default_battler.new
  end
  
  def default_battler
    # i really do not want to use the default battler... ah
    Game_Enemy.new(0,1)
  end
end


