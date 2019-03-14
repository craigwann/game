require 'gosu'
require_relative 'player'
require_relative 'enemy'
require_relative 'boss'
require_relative 'bosshead'
require_relative 'bullet'
require_relative 'explosion'
require_relative 'credit'

class SectorFive < Gosu::Window
    WIDTH = 1280
    HEIGHT = 800
    ENEMY_FREQUENCY = 0.025
    BOSS_FREQUENCY = 0.005
    MAX_ENEMIES = 100
  
    def initialize
        super(WIDTH,HEIGHT)
        self.caption = 'Sector 5'
        @player = Player.new(self)
        @enemies = []
        @bosses = []
        @bossheads = []
        @bullets = []
        @explosions = []
        @enemies_appeared = 0
        @enemies_destroyed = 0
        @background_game = Gosu::Image.new('images/background_stars.png')
        @game_music = Gosu::Song.new('sounds/Cephalopod.ogg')
        @game_music.play(true)
        @explosion_sound = Gosu::Sample.new('sounds/explosion.ogg')
        @shooting_sound = Gosu::Sample.new('sounds/shoot.ogg')
        @background_game = Gosu::Image.new('images/background_stars.png')
    end

    def update
        @player.turn_left if button_down?(Gosu::KbLeft)
        @player.turn_right if button_down?(Gosu::KbRight)
        @player.accelerate if button_down?(Gosu::KbUp)
        @player.move
        if rand < ENEMY_FREQUENCY
            @enemies.push Enemy.new(self)
        end

        if rand < BOSS_FREQUENCY
            @bosses.push Boss.new(self)
        end

        @enemies.each do |enemy|
            enemy.move
        end

        @bosses.each do |boss|
            boss.move
        end

        @bullets.each do |bullet|
            bullet.move
        end

        @enemies.dup.each do |enemy|
            @bullets.dup.each do |bullet|
              distance = Gosu.distance(enemy.x, enemy.y, bullet.x, bullet.y)
              if distance < enemy.radius + bullet.radius
                @enemies.delete enemy
                @bullets.delete bullet
                @explosions.push Explosion.new(self, enemy.x, enemy.y)
              end
            end
        end 

        @bosses.dup.each do |boss|
            @bullets.dup.each do |bullet|
              distance = Gosu.distance(boss.x, boss.y, bullet.x, bullet.y)
              if distance < boss.radius + bullet.radius
                @bosses.delete boss
                @bullets.delete bullet
                @explosions.push Explosion.new(self, boss.x, boss.y)
              end
            end
        end 


        @explosions.dup.each do |explosion|
            @explosions.delete explosion if explosion.finished
        end
        
        @enemies.dup.each do |enemy|
            if enemy.y > HEIGHT + enemy.radius
                @enemies.delete enemy 
            end
        end

        @bosses.dup.each do |boss|
            if boss.y > HEIGHT + boss.radius
                @bosses.delete boss 
            end
        end

        @bullets.dup.each do |bullet|
            @bullets.delete bullet unless bullet.onscreen?
        end
      
    end    

    def button_down(id)
        if id == Gosu::KbSpace
          @bullets.push Bullet.new(self, @player.x, @player.y, @player.angle)
        end
    end
  

    def draw
        @background_game.draw(0,0,0)
        @player.draw
        @enemies.each do |enemy|
            enemy.draw
        end

        @bosses.each do |boss|
            boss.draw
        end

        @bullets.each do |bullet|
            bullet.draw
        end
        
        @explosions.each do |explosion|
            explosion.draw
          end      
        
    end

end

window = SectorFive.new
window.show
