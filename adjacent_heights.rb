class AdjacentHeights

  attr_reader :north, :north_east, :east, :south_east, :south, :south_west, :west, :north_west

  def initialize( landscape:, x:, y: )
    x_min = 0
    x_max = landscape[0].length - 1
    y_min = 0
    y_max = landscape.length - 1
    @north = landscape[y-1][x] if y > y_min
    @north_east = landscape[y-1][x+1] if y > y_min && x < x_max
    @east = landscape[y][x+1] if x < x_max
    @south_east = landscape[y+1][x+1] if y < y_max && x < x_max
    @south = landscape[y+1][x] if y < y_max
    @south_west = landscape[y+1][x-1] if y < y_max && x > x_min
    @west = landscape[y][x-1] if x > x_min
    @north_west = landscape[y-1][x-1] if y > y_min && x > x_min
  end

  def directions_and_heights
    directions = [ :north, :north_east, :east, :south_east, :south, :south_west, :west, :north_west ]
    directions.each do |direction|
      yield direction, self.send( direction )
    end
  end

end
