module ItemContainer
  include SimpleTree
  attr_accessor :max_size
  attr_accessor :parent # a single item
  attr_accessor :children # array, items
  def contains(obj)
    children << obj if can_contain? obj
  end
  
  
  def children
    @children ||= []
  end
  
  def can_contain?(obj)
    return cur_size + obj <= max_size
  end

  def cur_size
    r = children.compact.inject(0.0) do |b,c|
            b += c.size
    end
    return r
  end
  
  def max_size
    @max_size ||= default_max_size
  end
  
  def default_max_size
    30
  end
  
  alias current_size cur_size
  alias container_size max_size
end

class Item
  include ItemContainer
end
