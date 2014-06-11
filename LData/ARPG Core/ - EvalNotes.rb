class RPG::Skill
  attr_reader :density
  attr_reader :startup, :recover, :active, :actions
  
  attr_reader :aub, :frame_advantage, :bullet
  attr_reader :projectile
  def eval_notes
    begin
      s = 4
      a = 3
      b = 2
      c = 1
      instance_eval self.note
    rescue
      puts "Id Error in Skill # #{self.id}"
    end
  end
end