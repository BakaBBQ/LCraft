# active frames, add fighting game frame counts into RGSS
class SokuState
  attr_accessor :startup, :active, :recover, :current_skill
  attr_accessor :skill
  def initialize(owner)
    @ended = true
    @owner = owner
#~     puts "i am a new one"
  end
  
  def reset(skill)
    @ended = false
    @skill = skill
    init_attributes
  end
  
  def ended?
    return @ended
  end
  
  def max_startup
    return @skill.startup + 1
  end
  
  def max_active
    return @skill.active + 1
  end
  
  def max_recover
    return @skill.recover + 1
  end
  
  def init_attributes
    @startup = 1
    @active = 0
    @recover = 0
  end
  
  def  active?
    return @active > 0
  end
  
  def startup?
    return @startup > 0
  end
  
  def recover?
    return @recover > 0
  end
  
  def update
    return if @ended
    update_attribute
  end
  
  def clear_all
   # puts "It is clearly clear that i have cleared all"
    
    @startup = 0
    @active = 0
    @recover = 0
  end
  
  def start_startup
    clear_all
    @startup = 1
  end
  
  def start_active
    clear_all
    @active = 1
  end
  
  def start_recover
    clear_all
    @recover = 1
  end
  
  def update_attribute
    @startup += 1 if @startup >= 1
    @active += 1 if @active >= 1
    @recover += 1 if @recover >= 1
#    puts "active : #{@startup}/ #{max_startup} recover: #{@active}/#{max_active}, ended: #{@recover}/#{max_recover}"
    start_active if @startup >= max_startup
    start_recover if @active >= max_active
    ended if @recover >= max_recover
    
    @owner.now_active(@active) if active?
  end
  
  def ended
  #  puts 'it is now ended'
    @ended = true
  end
end


# difference between Characters and Battlers are killing me
# this stupid inheritance is also killing me :x
Game_Character = Class.new Game_Character do
  attr_accessor :state
  def initialize
    super
    self.state = SokuState.new(self)
  end
  
  def update
    super
    update_state_related
  end
  
  def update_state_related
    self.state.update
    
  end
  
  def move_straight(*args)
    #puts 'hi'
    return unless self.state.ended?
    super(*args)
  end
  
  
  
  def use(skill_id)
    d = $data_skills[skill_id]
    self.state.reset(d)
    @current_skill = d
  end
  
  
  def now_active(frame)
    a = @current_skill.actions[frame]
    return unless a
    p = @current_skill.projectile
    instance_eval &a
  end
end

class Game_Character
  attr_accessor :direction
  def shoot_projectile(id, direction = -1)
    a = self.x
    b = self.y

    #puts self
    $game_map.projectile_tasks << [id,self, direction]
  end

  def left(x)
    return d2a(@direction) -x
  end
  alias :l :left
  
  def rand90
    return d2a(@direction) - 45 + rand(90)
  end
  
  def right(x)
    return d2a(@direction) + x
  end
  alias :r :right
  
  def back
  end
  def sp dr = nil
    shoot @current_skill.projectile, dr
  end
  
  alias shoot shoot_projectile
end