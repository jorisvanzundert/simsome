require_relative 'landscape'
require_relative 'agent'

def simulate( iterations: 1 )
  landscape = Landscape.new( name: 'Brave New World' )
  agent = Agent.new( name: 'Alquin', x: 80, y: 80, landscape: landscape )
  iterations.times {
    agent.move( direction: agent.decide[ :direction ] )
  }
  landscape.serialize( agent: agent, animate: true )
end

# MAIN
simulate( iterations: 50 )
