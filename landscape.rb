require_relative 'plasma_fractal'
require 'open3'
require 'shellwords'

class Landscape

  attr_accessor :height_map, :path_data_visualization_z_offset

  def initialize( name: nil, size: 129, height_seed: 400 )
    @map_name = name || File.basename(__FILE__).split('.')[0]
    fractal = PlasmaFractal.new( size: size, height_seed: height_seed )
    fractal.generate!
    @height_map = fractal.data
    @path_data_visualization_z_offset = 20
  end

  def survey_elevation( agent: nil )
    @height_map[ agent.y ][ agent.x ]
  end

  def survey_heights( x:, y: )
    survey = {}
    x_min = 0
    x_max = @height_map[0].length - 1
    y_min = 0
    y_max = @height_map.length - 1
    this_height = @height_map[y][x] if ( y >= y_min && y <= y_max ) && ( x >= x_min && x <= x_max )
    survey[ :north ] = @height_map[y-1][x] if y > y_min
    survey[ :north_east ] = @height_map[y-1][x+1] if y > y_min && x < x_max
    survey[ :east ] = @height_map[y][x+1] if x < x_max
    survey[ :south_east ] = @height_map[y+1][x+1] if y < y_max && x < x_max
    survey[ :south ] = @height_map[y+1][x] if y < y_max
    survey[ :south_west ] = @height_map[y+1][x-1] if y < y_max && x > x_min
    survey[ :west ] = @height_map[y][x-1] if x > x_min
    survey[ :north_west ] = @height_map[y-1][x-1] if y > y_min && x > x_min
    # Note_20181011_1302: Initially this reported absolute height values, which is wrong as estimates turn out wildly too big in that case. It is also incorrect intuitively: researchers estimate a relative leap to where they are, there is no such thing I think as absolute epistemological value. Making this error was useful though. Using relative values results in new behavior: having to decide what to do if you're on a local optimum (you can only go down), and going down can result in deadlock: going up again to the same local optimum, and down again, endlessly. This behavior might have puzzled me I think. Now I get to acknowledge it before it happens.
    # Map heights to relative heights (all a researcher can see).
    survey.each { |direction, height| survey[ direction ] = height - this_height }
  end

  def xyz_map
    map = ""
    @height_map.each_with_index do | row, y_index |
      row.each_with_index do | v, x_index |
        map << "#{x_index}\t#{y_index}\t#{v.to_i}\n"
      end
    end
    map
  end

  def serialize_grid
    File.open( "tmp/#{@map_name}.dat", 'w') { |file| file.write( self.xyz_map ) }
    commands = %Q(
      set table "tmp/#{@map_name}_grid_data.dat"
      set dgrid3d 50,50 gauss 4
      splot "tmp/#{@map_name}.dat" u 1:2:3
      unset table
      unset dgrid3d
    )
    Open3.capture3( 'gnuplot', :stdin_data => commands, :binmode => false )
    File.delete( "tmp/#{@map_name}.dat" )
  end

  def serialize_path_data( agent: nil )
    path_data = agent.path_data
    File.open( "tmp/agent_path.dat", 'w') { |file| file.write( path_data.map{ |way_point| "#{way_point[:x]} #{way_point[:y]} #{way_point[:elevation] + @path_data_visualization_z_offset}" }.join( "\n" ) ) }
  end

  def gnu_command_boilerplate
    pid = nil
    exit_status = nil
    boiler_plate = %Q(
      set terminal png size 4096,3072
      set output
      set zrange[150:650]
      set view 35, 130
      set xlabel "x"
      set ylabel "y"
      set style data lines
      set hidden3d
    )
    splot = "  splot 'tmp/#{@map_name}_grid_data.dat' u 1:2:3 w lines"
    commands = boiler_plate << splot
  end

  def serialize_frame( index: 0 )
    splot = ",\\\n        'tmp/agent_path.dat' u 1:2:3 every ::0::#{index} w lines lc rgb '#ff2222'"
    commands = gnu_command_boilerplate + splot
    png, stderr, status = Open3.capture3( 'gnuplot', :stdin_data => commands, :binmode => false )
    png
  end

  def serialize_frames( agent: nil, stdin: nil )
    end_index = agent.path_data.length - 1
    stdin ? start_index = 0 : start_index = end_index
    (start_index..end_index).each do |index|
      png, stderr, status = serialize_frame( index: index )
      print "▪︎" if index % 10 == 0
      stdin ? stdin.write( png ) : File.open( "tmp/#{@map_name}.png", "w" ) { |file| file.write( png ) }
    end
  end

  def serialize( agent: nil, animate: false )
    File.delete( "tmp/#{@map_name}.mov" ) if File.exist?( "tmp/#{@map_name}.mov" ) #ffmpeg doesn't overwrite
    serialize_grid
    serialize_path_data( agent: agent )
    if animate
      stdin, stdout_stderr, wait_thread = Open3.popen2e( "ffmpeg -pix_fmt yuv420p -i - -r 6 -vf format=yuv420p tmp/#{Shellwords.escape( @map_name )}.mov" )
      message_thread = Thread.new() do
        while messages = stdout_stderr.gets
          puts messages
        end
      end
    end
    puts "stdin: #{stdin}"
    serialize_frames( agent: agent, stdin: stdin )
    if animate
      message_thread.exit
      stdin.close
      stdout_stderr.close
    end
  end

end
