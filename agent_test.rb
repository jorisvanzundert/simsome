require_relative "agent"
require_relative "landscape"
require "test/unit"

class TestAgent < Test::Unit::TestCase

  def setup
    @agent = Agent.new( name: "Thomas" )
  end

  def test_estimate_effort
    300.times {
      factor = rand
      tile_height = 100 * factor
      estimate = @agent.estimate_effort( tile_height: tile_height )
      assert( estimate >= 0.25 * tile_height )
      assert( estimate <= 4 * tile_height )
    }
  end

  def test_decide
    @landscape = Landscape.new( size: 9, height_seed: 100 )
    @agent.decide( landscape: @landscape, tile_height: 0, capacity: 0)
  end

end
