class Enemy
    SPEED = 4
    attr_reader :x, :y, :radius

    def initialize(window)
      @radius = 30
      @x = rand(window.width - 2 * @radius) + @radius
      @y = 0
      @image = Gosu::Image.new('images/enemy.png') 
    end
    def draw
      @image.draw(@x - @radius, @y - @radius, 1)
    end
    def move
      @y += SPEED
    end
end