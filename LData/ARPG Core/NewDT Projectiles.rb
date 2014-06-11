module Kernel
  def d2a x 
    case x
     when 6
       0
     when 8
       270
      when 4
        180
      when 2
          90
      end
    end
end
    

class Projectile < Game_Event
  attr_accessor :hp
  attr_accessor :owner
  attr_reader :projectile
  attr_reader :event
  attr_accessor :opacity
  attr_accessor :angle
  def initialize(map_id, event)
    super(map_id, event)
    setup_projectile event.projectile_id
  end
  
  def setup_projectile id
    @projectile = $data_skills[id]
    @projectile.eval_notes
    @through = true
    @hp = density[1]
    @pspeed =  ori_speed
    @angle = rand(360)
  end
  
  def direction=(x)
     @angle = d2a x
  end
  
  def max_hp
    return density[1]
  end
  
  
  
      
  def screen_y
    super - 16
  end

  #direction conversion
  def single2two(direction)
    table = {
      1 => [4,2],
      3 => [6,2],
      7 => [4,8],
      9 => [6,8],
    }
    return table[direction]
  end
  
  def x
    return @real_x.to_i
  end
  
  def y
    return @real_y.to_i
  end
  
  
  def update_move
#~     @real_x = [@real_x - 0.1, @x].max if @x < @real_x
#~     @real_x = [@real_x + 0.1, @x].min if @x > @real_x
#~     @real_y = [@real_y - 0.05, @y].max if @y < @real_y
#~     @real_y = [@real_y + 0.05, @y].min if @y > @real_y
cas_c = p2c(0.1, @angle)
@real_x += cas_c[0]
@real_y += cas_c[1]
#~     update_bush_depth unless moving?
end

def moving?
  return true
end

  
  
  
  # redirecting diagonal movement
  def move_straight(d, turn_ok = true)
      @x = self.x
      @y = self.y
      increase_steps
  end
  
  
  
  def density
    return @projectile.density
  end
  
  def ori_speed
    return @projectile.speed
  end
  
  def die
    self.erase
  end
  
  def kill_judgement(projectile)
    if projectile.density[0] < self.density[0]
      projectile.die
    end
  end
  
  
   def distance_per_frame
     @pspeed
   end
   
   def p2c(l,a)
     r = d2r a
     i = l * Math.cos(r)
     j = l * Math.sin(r)
     return [i,j]
   end
   
   def d2r(d)
     return Math::PI / 180.0 * d
   end
   
   def r2d(r)
     return r * 180.0 / Math::PI
   end
   
   
  #projectile collide, should be called every frame when collided
  def projectile_collide(projectile)
    return if self.erased
    return if projectile.erased
    return if projectile.owner == self.owner
    return if projectile.projectile.id == self.projectile.id
    kill_judgement projectile
    @move_speed -= 0.1
    #puts self.hp
    self.hp -= 1
    if self.hp <= 0
      die
    end
    #@move_speed = ori_speed
  end
  
  #battler collide, should be called every frame when collided
  def battler_collide(battler)
    return if self.erased
    self.hp -= 1
    battler.hp -= 1
    @dying = true
    if self.hp <= 0
      die
    end
  end
  
  def hp=(x)
    @hp = x
    self.opacity = self.hp.to_f / max_hp.to_f * 255
  end
  
  def update
    self.hp -= 1 if @dying
    super
  end
  
  
end


class Game_Player
  def erased
    return false
  end
end
