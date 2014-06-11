class RPG::BaseItem
  def eval_notes
    instance_eval self.note
  end
end


class RPG::Item
  attr_accessor :material
end
