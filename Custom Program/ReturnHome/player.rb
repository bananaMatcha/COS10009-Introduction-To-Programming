class Player
 
    attr_reader :x, :y, :angle, :radius
    SPEED = 3
    def initialize(window)
        @x = 200
        @y = 650
        @image = Gosu::Image.new('images/ufo.png')
        @radius = 25
        @window = window
       
    end

    def draw
        @image.draw(@x - @radius, @y - @radius, 1)
    end

    def move_left()
        @x -= SPEED
       
    end
    def move_right()
        @x += SPEED
       
    end
    def move_up()
        @y -= SPEED
    end
    def move_down()
        @y += SPEED
    end
  
    def move
        move_left
        move_right
        move_up
        move_down
        if @x > @window.width - @radius
            @x =  @window.width - @radius #stop at the right edge
        end
        if @x < @radius 
            @x = @radius #stop at the left edge
        end
        if @y < @radius
            @y = @radius #stop at the top
        end
        if @y > @window.height - @radius
            @y =  @window.height - @radius #stop at the bottom
        end

    end
end
