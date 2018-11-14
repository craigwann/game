class Bosshead
    SPEED = 4
    attr_reader :x, :y, :radius
  
    def initialize(window)
      @radius = 40
      @x = rand(window.width - 2 * @radius) + @radius
      @y = 41
      @image = Gosu::Image.new('images/bosshead.png') 
      @velocity_x = 3
      @velocity_y = 2
      @window = window
    end
  
  
    def draw
      @image.draw(@x - @radius, @y - @radius, 1)
    end
    def move
      @x += @velocity_x
      @y += @velocity_y
      @velocity_x *= -1 if @x + @radius/2 > @window.width || @x - @radius/2 <0
      @velocity_y *= -1 if @y + @radius/2 > @window.height || @y - @radius/2 <0
    end
  end