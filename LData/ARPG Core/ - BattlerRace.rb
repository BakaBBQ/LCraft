Game_Battler = Class.new Game_Battler.clone do
  attr_accessor :race
  def initialize
    super
    @race = Human.new
  end
end