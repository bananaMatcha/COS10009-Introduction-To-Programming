
class Bullet
    SPEED = 5
    attr_reader :x, :y, :radius
  
    def initialize(window, x, y)
      @x = x
      @y = y
      @image = Gosu::Image.new('images/bullet.png')
      @radius = 4
      @window = window
    end
  
    def move
      @y -= SPEED
    end
  
    def draw
      @image.draw(@x - @radius, @y - @radius, 1)
    end
  
    def onscreen?
      @y > 0
    end
  end
  