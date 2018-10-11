require "test/unit"
require_relative "landscape"
require_relative "agent"

class TestLandscape < Test::Unit::TestCase

  def setup
    @landscape = Landscape.new( size: 9, height_seed: 100 )
    @mock_landscape = [[1,2,3],
                      [4,5,6],
                      [7,8,9]]
  end

  def test_square
    assert_equal( 9, @landscape.height_map.length )
    assert_equal( 9, @landscape.height_map[0].length )
  end

  def test_survey_heights
    surveyed_heights = @landscape.survey_heights( x: 0, y: 0 )
    assert_equal( nil, surveyed_heights[ :north_east ] )
    assert_equal( nil, surveyed_heights[ :north ] )
    assert_equal( nil, surveyed_heights[ :north_west ] )
    assert_equal( nil, surveyed_heights[ :west ] )
    assert_equal( nil, surveyed_heights[ :south_west ] )
    assert( surveyed_heights[ :south ] > 0 )
    assert( surveyed_heights[ :south_east ] > 0 )
    assert( surveyed_heights[ :east  ] > 0 )
  end

  def test_surveyed_tiles
    @landscape.height_map = @mock_landscape
    surveyed_heights = @landscape.survey_heights( x: 1, y: 1 )
    assert_equal( @mock_landscape[1][1], surveyed_heights[ :center ] )
    assert_equal( @mock_landscape[0][1], surveyed_heights[ :north ] )
    assert_equal( @mock_landscape[0][2], surveyed_heights[ :north_east ] )
    assert_equal( @mock_landscape[1][2], surveyed_heights[ :east ] )
    assert_equal( @mock_landscape[2][2], surveyed_heights[ :south_east ] )
    assert_equal( @mock_landscape[2][1], surveyed_heights[ :south ] )
    assert_equal( @mock_landscape[2][0], surveyed_heights[ :south_west ] )
    assert_equal( @mock_landscape[1][0], surveyed_heights[ :west ] )
    assert_equal( @mock_landscape[0][0], surveyed_heights[ :north_west ] )
  end

  def test_no_neighbors_nw
    @landscape.height_map = @mock_landscape
    surveyed_heights = @landscape.survey_heights( x: 0, y: 0 )
    assert_equal( @mock_landscape[0][0], surveyed_heights[ :center ] )
    assert_equal( nil, surveyed_heights[ :north ] )
    assert_equal( nil, surveyed_heights[ :north_east ] )
    assert_equal( @mock_landscape[0][1], surveyed_heights[ :east ] )
    assert_equal( @mock_landscape[1][1], surveyed_heights[ :south_east ] )
    assert_equal( @mock_landscape[1][0], surveyed_heights[ :south ] )
    assert_equal( nil, surveyed_heights[ :south_west ] )
    assert_equal( nil, surveyed_heights[ :west ] )
    assert_equal( nil, surveyed_heights[ :north_west ] )
  end

  def test_no_neighbors_ne
    @landscape.height_map = @mock_landscape
    surveyed_heights = @landscape.survey_heights( x: 2, y: 0 )
    assert_equal( @mock_landscape[0][2], surveyed_heights[ :center ] )
    assert_equal( nil, surveyed_heights[ :north ] )
    assert_equal( nil, surveyed_heights[ :north_east ] )
    assert_equal( nil, surveyed_heights[ :east ] )
    assert_equal( nil, surveyed_heights[ :south_east ] )
    assert_equal( @mock_landscape[1][2], surveyed_heights[ :south ] )
    assert_equal( @mock_landscape[1][1], surveyed_heights[ :south_west ] )
    assert_equal( @mock_landscape[0][1], surveyed_heights[ :west ] )
    assert_equal( nil, surveyed_heights[ :north_west ] )
  end

  def test_no_neighbors_se
    @landscape.height_map = @mock_landscape
    surveyed_heights = @landscape.survey_heights( x: 2, y: 2 )
    assert_equal( @mock_landscape[2][2], surveyed_heights[ :center ] )
    assert_equal( @mock_landscape[1][2], surveyed_heights[ :north ] )
    assert_equal( nil, surveyed_heights[ :north_east ] )
    assert_equal( nil, surveyed_heights[ :east ] )
    assert_equal( nil, surveyed_heights[ :south_east ] )
    assert_equal( nil, surveyed_heights[ :south ] )
    assert_equal( nil, surveyed_heights[ :south_west ] )
    assert_equal( @mock_landscape[2][1], surveyed_heights[ :west ] )
    assert_equal( @mock_landscape[1][1], surveyed_heights[ :north_west ] )
  end

  def test_no_neighbors_sw
    @landscape.height_map = @mock_landscape
    surveyed_heights = @landscape.survey_heights( x: 0, y: 2 )
    assert_equal( @mock_landscape[2][0], surveyed_heights[ :center ] )
    assert_equal( @mock_landscape[1][0], surveyed_heights[ :north ] )
    assert_equal( @mock_landscape[1][1], surveyed_heights[ :north_east ] )
    assert_equal( @mock_landscape[2][1], surveyed_heights[ :east ] )
    assert_equal( nil, surveyed_heights[ :south_east ] )
    assert_equal( nil, surveyed_heights[ :south ] )
    assert_equal( nil, surveyed_heights[ :south_west ] )
    assert_equal( nil, surveyed_heights[ :west ] )
    assert_equal( nil, surveyed_heights[ :north_west ] )
  end

  def test_no_neighbors_n
    @landscape.height_map = @mock_landscape
    surveyed_heights = @landscape.survey_heights( x: 1, y: 0 )
    assert_equal( @mock_landscape[0][1], surveyed_heights[ :center ] )
    assert_equal( nil, surveyed_heights[ :north ] )
    assert_equal( nil, surveyed_heights[ :north_east ] )
    assert_equal( @mock_landscape[0][2], surveyed_heights[ :east ] )
    assert_equal( @mock_landscape[1][2], surveyed_heights[ :south_east ] )
    assert_equal( @mock_landscape[1][1], surveyed_heights[ :south ] )
    assert_equal( @mock_landscape[1][0], surveyed_heights[ :south_west ] )
    assert_equal( @mock_landscape[0][0], surveyed_heights[ :west ] )
    assert_equal( nil, surveyed_heights[ :north_west ] )
  end

  def test_no_neighbors_e
    @landscape.height_map = @mock_landscape
    surveyed_heights = @landscape.survey_heights( x: 2, y: 1 )
    assert_equal( @mock_landscape[1][2], surveyed_heights[ :center ] )
    assert_equal( @mock_landscape[0][2], surveyed_heights[ :north ] )
    assert_equal( nil, surveyed_heights[ :north_east ] )
    assert_equal( nil, surveyed_heights[ :east ] )
    assert_equal( nil, surveyed_heights[ :south_east ] )
    assert_equal( @mock_landscape[2][2], surveyed_heights[ :south ] )
    assert_equal( @mock_landscape[2][1], surveyed_heights[ :south_west ] )
    assert_equal( @mock_landscape[1][1], surveyed_heights[ :west ] )
    assert_equal( @mock_landscape[0][1], surveyed_heights[ :north_west ] )
  end

  def test_no_neighbors_s
    @landscape.height_map = @mock_landscape
    surveyed_heights = @landscape.survey_heights( x: 1, y: 2 )
    assert_equal( @mock_landscape[2][1], surveyed_heights[ :center ] )
    assert_equal( @mock_landscape[1][1], surveyed_heights[ :north ] )
    assert_equal( @mock_landscape[1][2], surveyed_heights[ :north_east ] )
    assert_equal( @mock_landscape[2][2], surveyed_heights[ :east ] )
    assert_equal( nil, surveyed_heights[ :south_east ] )
    assert_equal( nil, surveyed_heights[ :south ] )
    assert_equal( nil, surveyed_heights[ :south_west ] )
    assert_equal( @mock_landscape[2][0], surveyed_heights[ :west ] )
    assert_equal( @mock_landscape[1][0], surveyed_heights[ :north_west ] )
  end

  def test_no_neighbors_w
    @landscape.height_map = @mock_landscape
    surveyed_heights = @landscape.survey_heights( x: 0, y: 1 )
    assert_equal( @mock_landscape[1][0], surveyed_heights[ :center ] )
    assert_equal( @mock_landscape[0][0], surveyed_heights[ :north ] )
    assert_equal( @mock_landscape[0][1], surveyed_heights[ :north_east ] )
    assert_equal( @mock_landscape[1][1], surveyed_heights[ :east ] )
    assert_equal( @mock_landscape[2][1], surveyed_heights[ :south_east ] )
    assert_equal( @mock_landscape[2][0], surveyed_heights[ :south ] )
    assert_equal( nil, surveyed_heights[ :south_west ] )
    assert_equal( nil, surveyed_heights[ :west ] )
    assert_equal( nil, surveyed_heights[ :north_west ] )
  end

  def test_survey_agent_elevation
    agent = Agent.new( name: "Constantijn", x: 4, y: 3, landscape: @landscape )
    assert_equal( @landscape.height_map[3][4], @landscape.survey_elevation( agent: agent ) )
  end

end
