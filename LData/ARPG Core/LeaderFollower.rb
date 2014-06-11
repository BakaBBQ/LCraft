=begin
if the battler has a unit, the unit has a leader, then follow it
=end

Game_Event = Class.new Game_Event.clone do
  def update_routine_move
#~     puts "updating routine move"
     if @wait_count > 0
      @wait_count -= 1
    else
      @move_succeed = true
      command = @move_route.list[@move_route_index]
#~       if command
        process_move_command(command)
        advance_move_route_index
#~       end
    end
  end
  
=begin

=end
   #--------------------------------------------------------------------------
  # ● 处理移动指令
  #--------------------------------------------------------------------------
  def process_move_command(command)
#~    puts "currently trying to process"
#~     puts self.unit.leader if self.unit
    if self.unit && self.unit.leader
      try_follow self.unit.leader
    end
  end
end
