#==============================================================================
# +++ MOG - Simple Anti Lag (V2.0) +++ 
#==============================================================================
# By Moghunter
# http://www.atelier-rgss.com
#==============================================================================
# Sistema de antilag. Basicamente faz com que o sistema não atualize os eventos
# fora da tela.
#==============================================================================
# Para forçar um evento atualizar fora da tela coloque este comentário no
# evento.
#
# <Force Update>
#
#==============================================================================
# Para desativar ou ativar o sistema de antilag use o comando abaixo
#
# $game_system.anti_lag = true
#
#==============================================================================
# NOTA - Este script não funciona em mapas com efeito LOOP.
# 
#==============================================================================
module MOG_ANTI_LAG
  #Area que será atualizada fora da tela. 
  UPDATE_OUT_SCREEN_RANGE = 3 
end

#==============================================================================
# ■ Game_System
#==============================================================================
class Game_System
  
  attr_accessor :anti_lag
  
 #--------------------------------------------------------------------------
 # ● Initialize
 #--------------------------------------------------------------------------   
  alias mog_antilag_initialize initialize
  def initialize
      @anti_lag = true
      mog_antilag_initialize
  end  
    
end

#==============================================================================
# ■ Game CharacterBase
#==============================================================================
class Game_CharacterBase
  
  attr_accessor :force_update
  attr_accessor :can_update
  
  #--------------------------------------------------------------------------
  # ● Init Public Members
  #--------------------------------------------------------------------------  
  alias mog_antilag_init_public_members init_public_members
  def init_public_members
      mog_antilag_init_public_members
      @force_update = false
      @can_update = true
  end
  
end

#==============================================================================
# ■ Game_Character
#==============================================================================
class Game_Event < Game_Character

  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------
  alias mog_anti_lag_initialize initialize
  def initialize(map_id, event)
      mog_anti_lag_initialize(map_id, event)
      anti_lag_initial_setup
  end
  
 #--------------------------------------------------------------------------
 # ● Setup Page Setting
 #--------------------------------------------------------------------------                     
  alias mog_antilag_setup_page_settings setup_page_settings
  def setup_page_settings
      mog_antilag_setup_page_settings
      set_force_update
  end
    
 #--------------------------------------------------------------------------
 # ● Set Force Update
 #--------------------------------------------------------------------------                       
  def set_force_update
      return if @list == nil
      for command in @list
          if command.code == 108
             @force_update = true if command.parameters[0] =~ /<Force Update>/
          end
      end 
   end  
  
  #--------------------------------------------------------------------------
  # ● Anti Lag Initial Setup
  #--------------------------------------------------------------------------  
  def anti_lag_initial_setup
      @can_update = true
      @loop_map = ($game_map.loop_horizontal? or $game_map.loop_vertical?) ? true : false
      out_screen = MOG_ANTI_LAG::UPDATE_OUT_SCREEN_RANGE
      @antilag_range = [-out_screen, 16 + out_screen,12 + out_screen]
  end
      
  #--------------------------------------------------------------------------
  # ● Anti Lag Force Update
  #--------------------------------------------------------------------------    
  def antilag_force_update?
      return true if !$game_system.anti_lag
      return true if @loop_map
      return true if @force_update
      return true if @trigger != nil and @trigger >= 3
      return true if anti_lag_event_on_screen?
      return false
  end  
    
 #--------------------------------------------------------------------------
 # ● Anti Lag Event On Screen?
 #--------------------------------------------------------------------------
 def anti_lag_event_on_screen?
     distance_x = @x - ($game_map.display_x).truncate
     distance_y = @y - ($game_map.display_y).truncate
     if distance_x.between?(@antilag_range[0], @antilag_range[1]) and
        distance_y.between?(@antilag_range[0], @antilag_range[2])
        return true
     end
     return false 
 end
  
 #--------------------------------------------------------------------------
 # ● Update
 #--------------------------------------------------------------------------     
  alias mog_anti_lag_update update
  def update
      @can_update = antilag_force_update?
      return if !@can_update 
      mog_anti_lag_update
  end
end

#==============================================================================
# ■ Sprite Character
#==============================================================================
class Sprite_Character < Sprite_Base

 #--------------------------------------------------------------------------
 # ● Check Can Update Sprite
 #--------------------------------------------------------------------------       
  def check_can_update_sprite
      if self.visible and !@character.can_update
         reset_sprite_effects
      end        
      self.visible = @character.can_update
      @balloon_sprite.visible = self.visible if @balloon_sprite != nil
  end
  
 #--------------------------------------------------------------------------
 # ● Reset Sprite Effects
 #--------------------------------------------------------------------------         
  def reset_sprite_effects
      dispose_animation
      dispose_balloon
  end

 #--------------------------------------------------------------------------
 # ● Update
 #--------------------------------------------------------------------------           
  alias mog_anti_lag_update update
  def update
      if @character.is_a?(Game_Event)
         check_can_update_sprite
         return if !self.visible
      end
      mog_anti_lag_update
  end
  
end

$mog_rgss3_anti_lag = true