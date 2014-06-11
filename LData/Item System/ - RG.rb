Scene_Map = Class.new Scene_Map do
  def update
    super
    SceneManager.call(ItemView) if Input.trigger?(:LETTER_V)
  end
end
