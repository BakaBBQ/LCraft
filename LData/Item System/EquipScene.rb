class EquipScene < Scene_MenuBase
  def start
    super
    create_actor_status
    create_actor_equips
    create_ava_equips
  end
end
