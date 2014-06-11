class Scene_None < Scene_Base
  def start
    super
    $data_skills.compact.each {|s| s.eval_notes}
    if DataManager.save_file_exists?
      SceneManager.call(Scene_Title)
    else
       DataManager.setup_new_game
      fadeout_all
      $game_map.autoplay
      SceneManager.goto(Scene_Map)
    end
  end
  
end

module SceneManager
   def self.first_scene_class
      $BTEST ? Scene_Battle : Scene_None
   end
 end
 