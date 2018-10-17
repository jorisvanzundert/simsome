require_relative 'landscape'
require_relative 'agent'

def simulate( iterations: 1 )
  landscape = Landscape.new( name: 'Brave New World' )
  agent = Agent.new( name: 'Alquin', x: 80, y: 80, landscape: landscape )
  iterations.times {
    agent.move( direction: agent.decide[ :direction ] )
  }
  landscape.visualize( agent: agent, animate: false )
  landscape.store( agent: agent )
end

# MAIN
sim_id = simulate( iterations: 3000 )

# Reloading the simulation data at a later point
# landscape = Landscape.new()
# agent = landscape.load( id: sim_id )
