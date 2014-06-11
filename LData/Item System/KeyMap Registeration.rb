module KeyMap
end


class KeyInfo
  attr_accessor :key # the key to trigger the target
  attr_accessor :target # proc, or something that is callable, can be empty only for hooking
  attr_accessor :description # the description, nothing related to the actual processing
  def initialize
    init_members
    yield self if block_given?
  end
  
  def init_members
  end
end

class KeyList
  def initialize
    @keys = []
  end
  
  def register(key, description, &target)
    info = KeyInfo.new do |i|
      i.key = key
      i.description = description
      i.target = target
    end
    @keys << info
  end
end