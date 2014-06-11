=begin
event battlers


read the event's name and then assign a battler to it
=end


Game_Event = Class.new Game_Event.clone do
  # for name reading
  def get_event_battler_id
    regex = /<battler=(\d+)>/
    md = regex.match revised_event_name
    
    if md
      return md[1].to_i
    else
      return 0
    end
  end
  
  def revised_event_name
    return @event.name.delete(" ").downcase
  end
  
  # main method, all above methods are helpers
  def get_battler
    id = get_event_battler_id
    if id == 0
      return default_battler
    else
      return Game_Enemy.new(0,id)
    end
  end
  
  def default_battler
    # i really do not want to use the default battler... ah
    Game_Enemy.new(0,1)
  end
  
  
  #--------------------------------------------------------------------------
  # ● Added Public Members - battler
  #--------------------------------------------------------------------------
  def initialize *args
    super *args
    @battler = get_battler
  end
end
