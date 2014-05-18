=begin
ParsedText is the middle format.
RMark files are supposed to be translated to ParsedText

ParsedText only has two kind of objects: RichText and Bitmap


The data within ParsedText is
[
  [richtext, bitmap, richtext, richtext], # line 0
  [bitmap...], # line 1
  etc
]

ParsedText is only a datatype. it does not handle any of the actual translating
=end


class RMark::ParsedText
  attr_accessor :data
  def initialize
    @data = Array.new{Array.new}
  end
  
  def process_line(line_number)
    yield line(line_number)
  end
  
  def line(line_number)
    return @data[line_number]
  end
end
