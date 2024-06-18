require 'gosu'
require_relative 'player'

require_relative 'bullet'
require_relative 'explosion'

class ReturnHome  < Gosu::Window
    WIDTH = 400
    HEIGHT = 800
    ASTEROID_FREQUENCY = 0.01
    FLASH_DURATION = 30  # Number of update cycles for the flashing effect
    RED_FLASH_COLOR = Gosu::Color::RED
    LIVES = 4
    def initialize
        super(WIDTH, HEIGHT) 
        self.caption = 'Return Home!'
        @player = Player.new(self) #in player.rb the Initialize() take window as argument. In here, window is (self)
        @asteroids =[] 
        @bullets =[]
        @explosions = []
        @background_image = Gosu::Image.new('images/starnight.png')
        @font = Gosu::Font.new(30)
        @damage = 0
        @time_left = (100 - (Gosu.milliseconds / 1000))
        @start_time = 0
        @playing = :true
        #flashing if hit
        @flash_counter = 0
        @flash = false
    end
    
    def draw()
        @font.draw(@time_left.to_s, 20, 20, 2)
        @background_image.draw(0, 0, 0)
        @player.draw
        @asteroids.each do |asteroid|
            asteroid.draw
        end
        @bullets.each do |bullet|
            bullet.draw
        end
        @explosions.each do |explosion|
            explosion.draw
        end
        if @flash
            draw_quad(0, 0, RED_FLASH_COLOR, WIDTH, 0, RED_FLASH_COLOR, WIDTH, HEIGHT, RED_FLASH_COLOR, 0, HEIGHT, RED_FLASH_COLOR)
        end   

        unless @playing
            @font.draw('Game Over', 110, 300, 3)
            @font.draw('Press P to Play again', 80, 350, 3)
            @background_image.draw(0,0,2)
            
        end
    end 

    def check_if_hit
        @asteroids.dup.each do |asteroid|
            distance = Gosu.distance(@player.x, @player.y, asteroid.x, asteroid.y)
            if distance < asteroid.radius + 25
                @asteroids.delete asteroid
                @explosions.push Explosion.new(self, asteroid.x, asteroid.y)
                @flash_counter = FLASH_DURATION
                @damage += 1
            end
        end
    end

    def shoot_asteroid
        @asteroids.dup.each do |asteroid|
            @bullets.dup.each do |bullet| 
                distance = Gosu.distance( asteroid.x, asteroid.y, bullet.x, bullet.y)
                if distance < asteroid.radius + bullet.radius
                    @asteroids.delete asteroid
                    @bullets.delete bullet
                    @explosions.push Explosion.new(self, asteroid.x, asteroid.y)
                end
            end
        end
    end

    def update
        @player.move_left if button_down?(Gosu::KbLeft)
        @player.move_right if button_down?(Gosu::KbRight)
        @player.move_up if button_down?(Gosu::KbUp)
        @player.move_down if button_down?(Gosu::KbDown)
        @player.move
        
        if rand < ASTEROID_FREQUENCY
            @asteroids.push(generate_asteroid)
        end
        @asteroids.each do |asteroid|
            asteroid.move
        end
        @bullets.each do |bullet|
            bullet.move
        end
        shoot_asteroid()
        check_if_hit()
        if @flash_counter > 0
            @flash_counter -= 1
            @flash = !@flash if @flash_counter % 10 == 0  # Toggle the flash every 10 update cycles
          else
            @flash = false  # Reset the flash
          end
        
        @explosions.dup.each do |explosion|
            @explosions.delete explosion if explosion.finished
        end
        
        @asteroids.dup.each do |asteroid|
            if asteroid.y > HEIGHT + asteroid.radius
                @asteroids.delete asteroid
            end
        end
        
        @bullets.dup.each do |bullet| 
            @bullets.delete bullet unless bullet.onscreen?
        end

        @time_left = (100 - ((Gosu.milliseconds - @start_time) / 1000))
        @playing = :win if @time_left < 0 && @damages < LIVES
        @playing = :lose if @damage == LIVES
        case @playing
        when :lose
        when :win
        when :not_playing
        end
        if @time_left < 0 || @damage == LIVES
            @playing = false
        end
        
    end
    def generate_asteroid
        case rand(3)
        when 0
            Asteroid.new('images/asteroid.png', self)
        when 1
            Asteroid.new('images/asteroid2.png', self)
        when 2
            Asteroid.new('images/asteroid3.png', self)
        end
    end
    def button_down(id)
        if @playing
            if id == Gosu::KbSpace
                @bullets.push Bullet.new(self, @player.x, @player.y)
            end
        else
            if (id == Gosu::KbP)
                @playing = true 
                @start_time = Gosu.milliseconds
                
            end
        end

    end
    class Asteroid
        SPEED = rand(1..5)
        attr_reader :x, :y, :radius
        def initialize(image, window)
          @radius = 25
          @x = rand(window.width - 2 * @radius) + @radius
          @y = 0
          @image = Gosu::Image.new(image)
        end
      
        def move
          @y += SPEED
          @y %= 800
        end
      
        def draw
          @image.draw(@x, @y, 1)
        end
      end
end
 
window = ReturnHome.new
window.show