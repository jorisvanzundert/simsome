require "test/unit"
require_relative "agent"
require_relative "landscape"

class TestAgent < Test::Unit::TestCase

  def setup
    @mock_height_map =  [[1,2,3],
                         [4,5,6],
                         [7,8,9]]
  end

  def test_estimate_effort
    agent = Agent.new( name: "Alquin" )
    300.times {
      factor = rand
      tile_height = 100 * factor
      estimate = agent.estimate_effort( tile_height: tile_height )
      assert( estimate >= 0.25 * tile_height )
      assert( estimate <= 4 * tile_height )
    }
  end

  def test_decide
    landscape = Landscape.new( size: 9, height_seed: 100 )
    agent = Agent.new( name: "Bernard", x: 2, y: 2, landscape: landscape )
    directions = [ :north, :north_east, :east, :south_east, :south, :south_west, :west, :north_west ]
    100.times {
      decision = agent.decide
      assert( decision[ :estimate ] > 0 )
      assert( directions.include? decision[ :direction ] )
    }
  end

  def test_moves
    agent = Agent.new( name: "Bernard", x: 1, y: 1 )
    assert_raise { agent.move( direction: :nowhere ) }
    assert_raise { agent.move }
    assert_equal( 1, agent.x )
    assert_equal( 1, agent.y )
    agent.move( direction: :north )
    assert_equal( 1, agent.x )
    assert_equal( 0, agent.y )
    agent.move( direction: :south )
    assert_equal( 1, agent.x )
    assert_equal( 1, agent.y )
    agent.move( direction: :east )
    assert_equal( 2, agent.x )
    assert_equal( 1, agent.y )
    agent.move( direction: :west )
    assert_equal( 1, agent.x )
    assert_equal( 1, agent.y )
    agent.move( direction: :south_west )
    assert_equal( 0, agent.x )
    assert_equal( 2, agent.y )
    agent.move( direction: :north_east )
    assert_equal( 1, agent.x )
    assert_equal( 1, agent.y )
    agent.move( direction: :south_east )
    assert_equal( 2, agent.x )
    assert_equal( 2, agent.y )
    agent.move( direction: :north_west )
    assert_equal( 1, agent.x )
    assert_equal( 1, agent.y )
  end

  def test_move
    landscape = Landscape.new( size: 3, height_seed: 1 )
    landscape.height_map = @mock_height_map
    agent = Agent.new( name: "Bernard", x: 1, y: 1, landscape: landscape )
    decision = agent.decide
    agent.move( direction: decision[ :direction ] )
    assert( agent.x != 1 || agent.y != 1 )
  end

end
