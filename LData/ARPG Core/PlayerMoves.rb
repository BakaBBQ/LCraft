#~ Game_Player = Class.new Game_Player.clone do
#~   attr_accessor :key_stacks #recording all keys entered
#~   attr_accessor :stack_timer #timer for keeping execution time accurate
#~   def execute_keys
#~     k = key_stacks.join
#~     execute_movement if pure_movement?
#~     puts k
#~     @key_stacks = []
#~   end
#~   
#~   def execute_movement
#~       move_straight(@key_stacks[0]) if movable?
#~   end
#~   
#~   
#~   def try_move(s)
#~   end
#~   
#~   
#~   def initialize
#~     super
#~     @key_stacks = []
#~     @key_timer = 0
#~     @stop_timer = 0
#~   end
#~   
#~   EXECUTION_KEYMAP = {
#~     2 => :LETTER_S,
#~     8 => :LETTER_W,
#~     4 => :LETTER_A,
#~     6 => :LETTER_D,
#~     :a => :LETTER_J,
#~     :b => :LETTER_K,
#~     :c => :LETTER_L,
#~    # :d => :LETTER_U,
#~     :e => :LETTER_I,
#~     :f => :LETTER_O
#~   }
#~   
#~   def update
#~     super
#~     record_keys
#~     check_execution
#~     @key_timer -= 1
#~     if moving?
#~       @stop_timer = 10
#~     else
#~       @stop_timer -= 1
#~       @pure_movement = false if @stop_timer <= 0
#~     end
#~     
#~   end
#~   
#~   def check_execution
#~     if @key_timer <= 0 && @key_stacks[0]
#~       execute_keys
#~     end
#~   end
#~   
#~   
#~   def record_keys
#~     
#~     EXECUTION_KEYMAP.each do |k,v|
#~       if Input.repeat?(v)
#~         break if @key_stacks.length > 0 && pure_movement?
#~         @key_stacks << k if one_pure?(@key_stacks.last) || one_pure?(v) || @key_stacks.empty?
#~         @key_timer = 8
#~         @key_timer = 0 if @pure_movement
#~       end
#~     end
#~     
#~   end
#~   
#~   def pure_movement?
#~     result = true
#~     @key_stacks.each do |k|
#~       result = false unless one_pure?(k)
#~     end
#~     @pure_movement = result
#~     return result
#~   end
#~   
#~   def one_pure?(k)
#~     [2,4,6,8,:LETTER_D].include? k
#~   end
#~   
#~   def move_by_input
#~    # super
#~   end
#~ end
