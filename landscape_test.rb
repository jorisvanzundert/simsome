require_relative "landscape"
require "test/unit"

class TestLandscape < Test::Unit::TestCase

  def setup
    @landscape = Landscape.new( size: 9, height_seed: 100 )
  end

  def test_square
    assert_equal( 9, @landscape.height_map.length )
    assert_equal( 9, @landscape.height_map[0].length )
  end

  def test_adjacent_heights
    ah = @landscape.adjacent_heights( x: 0, y: 0 )
    assert_equal( nil, ah.north_east )
    assert_equal( nil, ah.north )
    assert_equal( nil, ah.north_west )
    assert_equal( nil, ah.west )
    assert_equal( nil, ah.south_west )
    assert( ah.south > 0 )
    assert( ah.south_east > 0 )
    assert( ah.east > 0 )
  end

end
