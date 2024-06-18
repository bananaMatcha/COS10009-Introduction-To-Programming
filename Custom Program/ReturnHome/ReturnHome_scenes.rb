require 'gosu'
require_relative 'player'
require_relative 'bullet'
require_relative 'explosion'

class ReturnHome < Gosu::Window
    WIDTH = 400
    HEIGHT = 800
    ASTEROID_FREQUENCY = 0.02
    FLASH_DURATION = 30  # Number of update cycles for the flashing effect
    RED_FLASH_COLOR = Gosu::Color::RED
    LIVES = 4
    PLAYTIME = 10
    def initialize
        super(WIDTH, HEIGHT) 
        self.caption = 'Return Home!'
        @background_image = Gosu::Image.new('images/cover2.png')
        @scene = :start
        @start_music = Gosu::Song.new('sounds/newintro.mp3')
        @start_music.play(true)
    end

    def initialize_game
        @player = Player.new(self) #in player.rb the Initialize() take window as argument. In here, window is (self)
        @asteroids =[] 
        @bullets =[]
        @explosions = []
        @background_image = Gosu::Image.new('images/starnight.png')
        @font = Gosu::Font.new(30)
        @heart_image = Gosu::Image.new('images/heart.png')
        @heart = 0
        @damage = 0
        @time_left =PLAYTIME
        @start_time = Gosu.milliseconds #time from the game start counting in millisec
        @playing = :true
        #flashing if hit
        @flash_counter = 0
        @flash = false

        @scene = :game
        @game_music = Gosu::Song.new('sounds/newingame.mp3')
        @game_music.play(true)
        @explosion_sound = Gosu::Sample.new('sounds/bum.mp3')
    end
    def initialize_end(fate)
         #setting up the end screen
         @scene = :end
         case fate
         when :win
             @message = "Congratulation!"
             @message2 = "You are back home!!"
             @background_image = Gosu::Image.new('images/backhome.png')
             song = 'sounds/winn.mp3'
         when :lose
             @message = "       Oops!"
             @message2 = "You are not home yet..."
             @background_image = Gosu::Image.new('images/lost.png')
             song = 'sounds/lose.mp3'
       
     end
     @bottom_message = "Press P to play again \n or Q to quit."
     @message_font = Gosu::Font.new(30)
   
     @end_music = Gosu::Song.new(song)
     @end_music.play(true)
    end

    def draw
        case @scene
        when :start
            draw_start
        when :game
            draw_game
        when :end
            draw_end
        end
    end

    def draw_start
        @background_image.draw(-50,-50,0)
    end

    def draw_game
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

        @heart_image.draw(320, 25, 2)
        @font.draw(@heart.to_s, 350, 20, 2)
        if @flash
            draw_quad(0, 0, RED_FLASH_COLOR, WIDTH, 0, RED_FLASH_COLOR, WIDTH, HEIGHT, RED_FLASH_COLOR, 0, HEIGHT, RED_FLASH_COLOR)
        end   
    end

    def draw_end        
        @message_font.draw(@message,100,240,1,1,1,Gosu::Color::WHITE)
        @message_font.draw(@message2,70,290,1,1,1,Gosu::Color::WHITE)
        @message_font.draw(@bottom_message,80,540,1,1,1,Gosu::Color::WHITE)
        @background_image.draw(0,0,0)
    end
  
    def button_down(id)
        case @scene
        when :start
          button_down_start(id)
        when :game
          button_down_game(id)
        when :end
          button_down_end(id)
        end
    end

    def update
        #move player
        if @scene == :game
        @player.move_left if button_down?(Gosu::KbLeft)
        @player.move_right if button_down?(Gosu::KbRight)
        @player.move_up if button_down?(Gosu::KbUp)
        @player.move_down if button_down?(Gosu::KbDown)
        @player.move
        
        #create objects
        if rand < ASTEROID_FREQUENCY
            @asteroids.push(generate_asteroid)
        end

        @asteroids.each do |asteroid|
            asteroid.move
        end
        @bullets.each do |bullet|
            bullet.move
        end
     
        #clear objects
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

        flash_effect
        #check collision between bullets and asteroids
        bullet_asteroid_collide?   
        #check collision between players and asteroids
        @heart = LIVES - @damage if player_asteroid_collide?

        @time_left = (PLAYTIME - ((Gosu.milliseconds - @start_time) / 1000))
        initialize_end(:win) if @time_left == 0 && @damage < LIVES
        initialize_end(:lose) if @damage == LIVES
    end
    def flash_effect
        if @flash_counter > 0
            @flash_counter -= 1
            @flash = !@flash if @flash_counter % 10 == 0  # check when @flash_counter is a multiple of 10 to Toggle the flash every 10 update cycles
        else
            @flash = false  # Reset the flash
        end
    end

    def  bullet_asteroid_collide?
        @asteroids.dup.each do |asteroid|
            @bullets.dup.each do |bullet| 
                distance = Gosu.distance( asteroid.x, asteroid.y, bullet.x, bullet.y )
                if distance < asteroid.radius + bullet.radius
                    @asteroids.delete(asteroid)
                    @bullets.delete(bullet)
                    @explosions.push(Explosion.new(self, asteroid.x, asteroid.y))
                    @explosion_sound.play
                end
            end
        end   
    end

    def player_asteroid_collide?
          #check collision between players and asteroids
          @asteroids.dup.each do |asteroid|
            distance = Gosu.distance(@player.x, @player.y , asteroid.x, asteroid.y)
            if distance < asteroid.radius + @player.radius
                @asteroids.delete asteroid
                @explosions.push Explosion.new(self, asteroid.x, asteroid.y)
                @explosion_sound.play
                @flash_counter = FLASH_DURATION
                @damage += 1
            end
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

    def button_down_start(id)
        initialize_game if id == Gosu::KbS #Press S to start the game
    end

    def button_down_game(id)
        if @playing
            if id == Gosu::KbSpace
                @bullets.push Bullet.new(self, @player.x, @player.y)
            end
        end
        
    end
    def button_down_end(id)
        if id == Gosu::KbP 
        initialize_game
        elsif id == Gosu::KbQ
            close
        end
    end
end
    class Asteroid
        SPEED = rand(1.5..5)
        attr_reader :x, :y, :radius
        def initialize(image, window)
          @radius = 25
          @x = rand(window.width - 2 * @radius) 
          @y = 0
          @image = Gosu::Image.new(image)
        end
      
        def move
          @y += SPEED
          @y %= 800
        end
      
        def draw
          @image.draw(@x - @radius, @y - @radius, 1)
        end
      end
end

window = ReturnHome.new
window.show