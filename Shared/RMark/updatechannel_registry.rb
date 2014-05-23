module RMark::Window
  def create_channel(*args)
    @uc ||= RMark::UpdateChannel.new(*args)
  end
  
  def update_channel
    @uc.update
  end
end