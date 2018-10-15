require "test/unit"
require_relative "agent"
require_relative "landscape"

class TestAgent < Test::Unit::TestCase

  def setup
    @mock_height_map =  [[1,2,3],
                         [4,5,6],
                         [7,8,9]]
    @mock_negative_map = [[1,2,3],
                          [4,9,5],
                          [6,7,8]]
  end

# I'll leave this in here as a modern variant of a doodle
#
#          v..||
#   ..v     ||
#    .     v.||
#   |.v     .|
#    |     v..|
#  |..v     |
#   |.     v.|
#  ||.v     .
#   ||     v..
# ||..v

  def test_estimate_effort
    landscape = Landscape.new( size: 3, height_seed: 1 )
    landscape.height_map = @mock_height_map
    agent = Agent.new( name: "Alcuin of York", x: 1, y: 1, landscape: landscape )
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
    agent = Agent.new( name: "Bernard of Clairvaux", x: 2, y: 2, landscape: landscape )
    directions = [ :north, :north_east, :east, :south_east, :south, :south_west, :west, :north_west ]
    100.times {
      decision = agent.decide
      assert( decision[ :estimate ] > 0 )
      assert( directions.include? decision[ :direction ] )
    }
  end

  def test_moves
    landscape = Landscape.new( size: 3, height_seed: 1 )
    agent = Agent.new( name: "Christiaan Huygens", x: 1, y: 1, landscape: landscape )
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
    agent = Agent.new( name: "Daniel Bernoulli", x: 1, y: 1, landscape: landscape )
    decision = agent.decide
    agent.move( direction: decision[ :direction ] )
    assert( agent.x != 1 || agent.y != 1 )
  end

  def test_all_directions_negative
    # What does a researcher do when they only way seems to be down? My bet is again on thre side of some conservatism: the researcher will choose a direction that causes least loss. This solution will require a penalty of some kind for going in the direction one came from, or in the next step the researcher will just head back up the local optimum just left. And of course to realize that, an agent will have to have some form of epistemic memory.
    landscape = Landscape.new( size: 3, height_seed: 1 )
    landscape.height_map = @mock_negative_map
    agent = Agent.new( name: "Euclidius", x: 1, y: 1, landscape: landscape )
    decision = agent.decide
    puts decision
    # TODO: Change this so it checks if agent.choose_conservative returns a number clostes above zero, or failing that a number closests below zero.
    agent.move( direction: decision[ :direction ] )
    assert( agent.x == 2 && agent.y == 2 )
  end

  def test_epistemic_memory
    landscape = Landscape.new( size: 3, height_seed: 1 )
    landscape.height_map = @mock_negative_map
    agent = Agent.new( name: "Fibonacci", x: 1, y: 1, landscape: landscape )
    agent.move( direction: :north ) # => 2
    agent.move( direction: :east ) # => 3
    agent.move( direction: :south ) # => 5
    agent.move( direction: :west ) # => 9
    agent.move( direction: :south ) # => 7
    agent.move( direction: :east ) # => 8
    agent.move( direction: :west ) # => 7
    agent.move( direction: :west ) # => 6
    agent.move( direction: :north ) # => 4
    agent.move( direction: :east ) # => 9
    expected_path_data = [ { :x => 1, :y => 1, :elevation => 9 },
                           { :x => 1, :y => 0, :elevation => 2 },
                           { :x => 2, :y => 0, :elevation => 3 },
                           { :x => 2, :y => 1, :elevation => 5 },
                           { :x => 1, :y => 1, :elevation => 9 },
                           { :x => 1, :y => 2, :elevation => 7 },
                           { :x => 2, :y => 2, :elevation => 8 },
                           { :x => 1, :y => 2, :elevation => 7 },
                           { :x => 0, :y => 2, :elevation => 6 },
                           { :x => 0, :y => 1, :elevation => 4 },
                           { :x => 1, :y => 1, :elevation => 9 } ]
    assert_equal( expected_path_data, agent.path_data )
  end

end
