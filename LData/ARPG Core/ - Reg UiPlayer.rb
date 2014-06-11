Scene_Map = Class.new Scene_Map do
  def create_all_windows
    super
    @ui_player = UiPlayer.new
  end
  
end
