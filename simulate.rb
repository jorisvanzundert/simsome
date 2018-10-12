require_relative 'landscape'
require_relative 'agent'

def simulate( iterations: 1 )
  landscape = Landscape.new( name: 'Brave New World' )
  agent = Agent.new( name: 'Alquin', x: 80, y: 80, landscape: landscape )
  agent_path_data = [ "#{agent.x} #{agent.y} #{landscape.survey_elevation( agent: agent ) + 20}" ]
  frame_number = 0
  iterations.times {
    agent.move( direction: agent.decide[ :direction ] )
    agent_path_data << "#{agent.x} #{agent.y} #{landscape.survey_elevation( agent: agent ) + 20}"
  }
  landscape.serialize( agent_path_data: agent_path_data, animate: true )
end

# MAIN
simulate( iterations: 300 )
