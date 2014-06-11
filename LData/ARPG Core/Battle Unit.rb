class Game_Character
  attr_accessor :unit
end


class Battle_Unit
  attr_accessor :members
  attr_accessor :leader
  attr_accessor :name
  def initialize
    @members = []
    @leader = nil
    @name = "未命名"
  end
  
  def join(battler)
    battler.unit = self
    @members << battler
    puts "joined"
    puts $scene.class
    SceneManager.scene.get_spriteset.refresh_gauges if SceneManager.scene.is_a? Scene_Map
  end
end

class Unit_Command
  attr_accessor :stay, :fight
  def initialize
    @stay = false
    @fight = true
  end
end

class Game_Character
  def try_follow(character)
   # return if character.moving?
    return if character.ava_coords.include?([self.x, self.y])
    fx, fy = false, false
    time = Time.now
    character.ava_coords.each do |c|
      if Path_Core.runnable?(self,c[0],c[1]) #&& Path_Core.run(self,c[0],c[1])
        fx, fy = c[0], c[1]
      end
    end
    puts Time.now - time
    unless fx || fy
      return
    end
   return unless Path_Core.runnable?(self,fx,fy)
    path = Path_Core.run(self,fx,fy)
    if path.nil?
     @wait_count = 60 - 1
      return
    end
    
      
    return if self.x == fx && self.y == fy
    puts "yes it actually reached here"
    path << 0x00
    code = {1=>2,2=>4,3=>6,4=>8}[path[0]]
    puts code
      move_straight code
    end 
    
    
    
    def ava_coords
      r = [
        [self.x, self.y - 1],
        [self.x + 1, self.y],
        [self.x - 1, self.y],
        [self.x, self.y + 1],
        [self.x + 1, self.y + 1],
        [self.x - 1, self.y - 1],
         [self.x + 1, self.y - 1],
          [self.x - 1, self.y + 1],
      ]
      return r
    end
    
    
  def create_unit
    @my_unit = Battle_Unit.new
    @my_unit.join self
    @my_unit.leader = self
  end
  
  def join_party(x)
    x.unit.join self
  end
end