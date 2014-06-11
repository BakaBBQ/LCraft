Scene_Title = Class.new Scene_Title.clone do
  def start
    super
    [$data_skills].each do |d|
      d.compact.each do |element|
        element.eval_notes
      end
    end
  end
end
