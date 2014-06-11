module RPackage
  PACKAGE_DIRECTORY = "../LData/"
  DEFAULT_SCRIPTS = ["▼ 模块", "Vocab", "Sound", "Cache", "DataManager", "SceneManager", "BattleManager", "▼ 对象", "Game_Temp", "Game_System", "Game_Timer", "Game_Message", "Game_Switches", "Game_Variables", "Game_SelfSwitches", "Game_Screen", "Game_Picture", "Game_Pictures", "Game_BaseItem", "Game_Action", "Game_ActionResult", "Game_BattlerBase", "Game_Battler", "Game_Actor", "Game_Enemy", "Game_Actors", "Game_Unit", "Game_Party", "Game_Troop", "Game_Map", "Game_CommonEvent", "Game_CharacterBase", "Game_Character", "Game_Player", "Game_Follower", "Game_Followers", "Game_Vehicle", "Game_Event", "Game_Interpreter", "▼ 精灵", "Sprite_Base", "Sprite_Character", "Sprite_Battler", "Sprite_Picture", "Sprite_Timer", "Spriteset_Weather", "Spriteset_Map", "Spriteset_Battle", "▼ 窗口", "Window_Base", "Window_Selectable", "Window_Command", "Window_HorzCommand", "Window_Help", "Window_Gold", "Window_MenuCommand", "Window_MenuStatus", "Window_MenuActor", "Window_ItemCategory", "Window_ItemList", "Window_SkillCommand", "Window_SkillStatus", "Window_SkillList", "Window_EquipStatus", "Window_EquipCommand", "Window_EquipSlot", "Window_EquipItem", "Window_Status", "Window_SaveFile", "Window_ShopCommand", "Window_ShopBuy", "Window_ShopSell", "Window_ShopNumber", "Window_ShopStatus", "Window_NameEdit", "Window_NameInput", "Window_ChoiceList", "Window_NumberInput", "Window_KeyItem", "Window_Message", "Window_ScrollText", "Window_MapName", "Window_BattleLog", "Window_PartyCommand", "Window_ActorCommand", "Window_BattleStatus", "Window_BattleActor", "Window_BattleEnemy", "Window_BattleSkill", "Window_BattleItem", "Window_TitleCommand", "Window_GameEnd", "Window_DebugLeft", "Window_DebugRight", "▼ 场景", "Scene_Base", "Scene_Title", "Scene_Map", "Scene_MenuBase", "Scene_Menu", "Scene_ItemBase", "Scene_Item", "Scene_Skill", "Scene_Equip", "Scene_Status", "Scene_File", "Scene_Save", "Scene_Load", "Scene_End", "Scene_Shop", "Scene_Name", "Scene_Debug", "Scene_Battle", "Scene_Gameover",  "▼ 插件脚本","(请在此添加)", "▼ 入口", "Main"]
  def load_package(package_name)
    filenames = parse_package(File.open(PACKAGE_DIRECTORY + package_name + "/[package].rb").read)
    filenames.each do |fn|
      requrie(PACKAGE_DIRECTORY + package_name + "/#{fn}")
    end
  end
  
  def parse_package(str)
    return eval(str)
  end
  
  def save_to_package(package_name)
    n = PACKAGE_DIRECTORY + package_name
    if File.exist?(n)
        puts "[WARNING] Package Already Exist!"
      else
        Dir.mkdir(n)
      end
    filenames = []
    $RGSS_SCRIPTS.each do |s|
      filename = s[1]
      
      contents = Zlib::Inflate.inflate(s[2])
      
      
      
      next if filename == ""
      next if DEFAULT_SCRIPTS.include?(filename)
      next if filename.downcase["nopack"]
      File.open(PACKAGE_DIRECTORY + package_name + "/#{filename}.rb", "w+") do |f|
        f.write contents
      end
      filenames << filename
      
    end # $RGSS_SCRIPTS
    File.open(PACKAGE_DIRECTORY + package_name + "/[package].rb","w+")  do |f|
      f.write filenames.to_s
    end
    
  end
end

include RPackage
save_to_package("RPackage")
