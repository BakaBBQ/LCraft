class Projectile
  def update
    return if self.erased
    @timer ||= 0
    @timer += 1
    if @timer >= 120
      @dying = true
    end
    
    self.hp -= 1 if @dying
    super
    colliding_projectiles.each do |p|
      projectile_collide p
    end
    
    colliding_battlers.each do |b|
      battler_collide b
    end
  end
  
end
