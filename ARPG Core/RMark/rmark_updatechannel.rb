class RMark::UpdateChannel
  attr_accessor :owner, :targets
  def initialize(*variables, owner)
    owner = owner
    targets = variables
    
    @owner = owner
    @targets = targets
    @ori_targets = deep_clone targets
  end
  
  def deep_clone obj
    return Marshal.load(Marshal.dump(obj))
  end
  
  def update
    if @ori_targets != @targets
#~       puts 'refreshing'
      owner.refresh
    end
    @ori_targets = deep_clone @targets
  end
end