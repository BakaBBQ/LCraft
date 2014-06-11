class Window
  def load_view(filename)
    filename+=".rmd" unless filename.include?('.rmd')
    load_file("./Views/#{filename}")
  end
end
