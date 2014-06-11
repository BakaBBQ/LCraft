#~ class Game_BattlerBase 
#~   alias :lbq_gamebattlerbase_init_mana :initialize
#~   def initialize(*args)
#~     lbq_gamebattlerbase_init_mana *args
#~     @mp = ManaPoint.new
#~   end
#~   
#~   def mp
#~     return [@mp.point, mmp].min #rescue @mp.point
#~   end
#~   
#~   def mp_obj
#~     return @mp
#~   end
#~   
#~   
#~   #--------------------------------------------------------------------------
#~   # ● 更改 MP 
#~   #--------------------------------------------------------------------------
#~   def mp=(mp)
#~     @mp.point = mp
#~     refresh
#~   end
#~   
#~   #--------------------------------------------------------------------------
#~   # ● 完全恢复
#~   #--------------------------------------------------------------------------
#~   def recover_all
#~     clear_states
#~     @hp = mhp
#~     @mp.point = mmp
#~   end
#~   
#~ end
