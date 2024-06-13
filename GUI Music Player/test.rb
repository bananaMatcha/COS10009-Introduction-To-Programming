require 'gosu'

class TextHeightExample < Gosu::Window
  def initialize
    super(400, 200)
    self.caption = "Text Height Example"

    @font_size = 25
    @text = "Sample text to measure"
    @font = Gosu::Font.new(25)

    # Measure the text height
    @text_height = @font.text_height(@text)
  end

  def draw
    # Display the text and its measured height
    @font.draw_text(@text, 20, 20, 0, 1.0, 1.0, Gosu::Color::WHITE)
    Gosu.draw_rect(20, 40, 200, @text_height, Gosu::Color::GRAY) # Highlight the text area
    @font.draw_text("Text Height: #{@text_height}", 20, 50, 0, 1.0, 1.0, Gosu::Color::WHITE)
  end
end

# Run the application
TextHeightExample.new.show
