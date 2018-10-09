require_relative "adjacent_heights"
require "test/unit"

class AdjacentHeightsTest < Test::Unit::TestCase

  def setup
    @landscape = [[1,2,3],
                  [4,5,6],
                  [7,8,9]]
  end

  def test_adajacent_tiles
    adjacent_heights = AdjacentHeights.new( landscape: @landscape, x: 1, y: 1 )
    assert_equal( @landscape[0][1], adjacent_heights.north )
    assert_equal( @landscape[0][2], adjacent_heights.north_east )
    assert_equal( @landscape[1][2], adjacent_heights.east )
    assert_equal( @landscape[2][2], adjacent_heights.south_east )
    assert_equal( @landscape[2][1], adjacent_heights.south )
    assert_equal( @landscape[2][0], adjacent_heights.south_west )
    assert_equal( @landscape[1][0], adjacent_heights.west )
    assert_equal( @landscape[0][0], adjacent_heights.north_west )
  end

  def test_no_neighbors_nw
    adjacent_heights = AdjacentHeights.new( landscape: @landscape, x: 0, y: 0 )
    assert_equal( nil, adjacent_heights.north )
    assert_equal( nil, adjacent_heights.north_east )
    assert_equal( @landscape[0][1], adjacent_heights.east )
    assert_equal( @landscape[1][1], adjacent_heights.south_east )
    assert_equal( @landscape[1][0], adjacent_heights.south )
    assert_equal( nil, adjacent_heights.south_west )
    assert_equal( nil, adjacent_heights.west )
    assert_equal( nil, adjacent_heights.north_west )
  end

  def test_no_neighbors_ne
    adjacent_heights = AdjacentHeights.new( landscape: @landscape, x: 2, y: 0 )
    assert_equal( nil, adjacent_heights.north )
    assert_equal( nil, adjacent_heights.north_east )
    assert_equal( nil, adjacent_heights.east )
    assert_equal( nil, adjacent_heights.south_east )
    assert_equal( @landscape[1][2], adjacent_heights.south )
    assert_equal( @landscape[1][1], adjacent_heights.south_west )
    assert_equal( @landscape[0][1], adjacent_heights.west )
    assert_equal( nil, adjacent_heights.north_west )
  end

  def test_no_neighbors_se
    adjacent_heights = AdjacentHeights.new( landscape: @landscape, x: 2, y: 2 )
    assert_equal( @landscape[1][2], adjacent_heights.north )
    assert_equal( nil, adjacent_heights.north_east )
    assert_equal( nil, adjacent_heights.east )
    assert_equal( nil, adjacent_heights.south_east )
    assert_equal( nil, adjacent_heights.south )
    assert_equal( nil, adjacent_heights.south_west )
    assert_equal( @landscape[2][1], adjacent_heights.west )
    assert_equal( @landscape[1][1], adjacent_heights.north_west )
  end

  def test_no_neighbors_sw
    adjacent_heights = AdjacentHeights.new( landscape: @landscape, x: 0, y: 2 )
    assert_equal( @landscape[1][0], adjacent_heights.north )
    assert_equal( @landscape[1][1], adjacent_heights.north_east )
    assert_equal( @landscape[2][1], adjacent_heights.east )
    assert_equal( nil, adjacent_heights.south_east )
    assert_equal( nil, adjacent_heights.south )
    assert_equal( nil, adjacent_heights.south_west )
    assert_equal( nil, adjacent_heights.west )
    assert_equal( nil, adjacent_heights.north_west )
  end

  def test_no_neighbors_n
    adjacent_heights = AdjacentHeights.new( landscape: @landscape, x: 1, y: 0 )
    assert_equal( nil, adjacent_heights.north )
    assert_equal( nil, adjacent_heights.north_east )
    assert_equal( @landscape[0][2], adjacent_heights.east )
    assert_equal( @landscape[1][2], adjacent_heights.south_east )
    assert_equal( @landscape[1][1], adjacent_heights.south )
    assert_equal( @landscape[1][0], adjacent_heights.south_west )
    assert_equal( @landscape[0][0], adjacent_heights.west )
    assert_equal( nil, adjacent_heights.north_west )
  end

  def test_no_neighbors_e
    adjacent_heights = AdjacentHeights.new( landscape: @landscape, x: 2, y: 1 )
    assert_equal( @landscape[0][2], adjacent_heights.north )
    assert_equal( nil, adjacent_heights.north_east )
    assert_equal( nil, adjacent_heights.east )
    assert_equal( nil, adjacent_heights.south_east )
    assert_equal( @landscape[2][2], adjacent_heights.south )
    assert_equal( @landscape[2][1], adjacent_heights.south_west )
    assert_equal( @landscape[1][1], adjacent_heights.west )
    assert_equal( @landscape[0][1], adjacent_heights.north_west )
  end

  def test_no_neighbors_s
    adjacent_heights = AdjacentHeights.new( landscape: @landscape, x: 1, y: 2 )
    assert_equal( @landscape[1][1], adjacent_heights.north )
    assert_equal( @landscape[1][2], adjacent_heights.north_east )
    assert_equal( @landscape[2][2], adjacent_heights.east )
    assert_equal( nil, adjacent_heights.south_east )
    assert_equal( nil, adjacent_heights.south )
    assert_equal( nil, adjacent_heights.south_west )
    assert_equal( @landscape[2][0], adjacent_heights.west )
    assert_equal( @landscape[1][0], adjacent_heights.north_west )
  end

  def test_no_neighbors_w
    adjacent_heights = AdjacentHeights.new( landscape: @landscape, x: 0, y: 1 )
    assert_equal( @landscape[0][0], adjacent_heights.north )
    assert_equal( @landscape[0][1], adjacent_heights.north_east )
    assert_equal( @landscape[1][1], adjacent_heights.east )
    assert_equal( @landscape[2][1], adjacent_heights.south_east )
    assert_equal( @landscape[2][0], adjacent_heights.south )
    assert_equal( nil, adjacent_heights.south_west )
    assert_equal( nil, adjacent_heights.west )
    assert_equal( nil, adjacent_heights.north_west )
  end

  def test_directions_and_heights
    adjacent_heights = AdjacentHeights.new( landscape: @landscape, x: 1, y: 1 )
    expected = "north2north_east3east6wouth_east9south8south_west7west4north_west1"
    result = ""
    adjacent_heights.directions_and_heights { |direction, height| result << "#{direction}#{height}" }
  end

end
