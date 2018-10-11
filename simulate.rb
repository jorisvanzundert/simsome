require_relative 'landscape'
require_relative 'agent'

landscape = Landscape.new( name: 'Brave New World' )
agent = Agent.new( name: 'Alquin', x: 80, y: 80, landscape: landscape )
agent_path_data = ""
File.open( "tmp/agent_path_start.dat", 'w') { |file| file.write( "#{agent.x} #{agent.y} #{landscape.survey_elevation( agent: agent ) + 20}\n" ) }
3000.times {
  agent.move( direction: agent.decide[ :direction ] )
  agent_path_data << "#{agent.x} #{agent.y} #{landscape.survey_elevation( agent: agent ) + 20}\n"
}
File.open( "tmp/agent_path_end.dat", 'w') { |file| file.write( "#{agent.x} #{agent.y} #{landscape.survey_elevation( agent: agent ) + 20}\n" ) }
landscape.serialize( agent_path_data: agent_path_data )
