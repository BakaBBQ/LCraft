=begin
EquipUtils - For Quick Accessing Equip
---------------------------------------------------
=end


module EquipUtils # include in battler
  def equip(item, part) # all parts are written in class names
    body.part.wielding = item
  end
end