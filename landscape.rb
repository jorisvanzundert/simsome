require_relative 'plasma_fractal'
require 'open3'

class Landscape

  attr_accessor :height_map

  def initialize( name: nil, size: 129, height_seed: 400 )
    @map_name = name || File.basename(__FILE__).split('.')[0]
    fractal = PlasmaFractal.new( size: size, height_seed: height_seed )
    fractal.generate!
    @height_map = fractal.data
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
    survey[ :center ] = @height_map[y][x] if ( y >= y_min && y <= y_max ) && ( x >= x_min && x <= x_max )
    survey[ :north ] = @height_map[y-1][x] if y > y_min
    survey[ :north_east ] = @height_map[y-1][x+1] if y > y_min && x < x_max
    survey[ :east ] = @height_map[y][x+1] if x < x_max
    survey[ :south_east ] = @height_map[y+1][x+1] if y < y_max && x < x_max
    survey[ :south ] = @height_map[y+1][x] if y < y_max
    survey[ :south_west ] = @height_map[y+1][x-1] if y < y_max && x > x_min
    survey[ :west ] = @height_map[y][x-1] if x > x_min
    survey[ :north_west ] = @height_map[y-1][x-1] if y > y_min && x > x_min
    survey
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

  def gnuplot( commands )
    IO.popen( "gnuplot", "w" ) { |io| io.puts commands }
  end

  def apngasm( commands )
    IO.popen( "apngasm", "w" ) { |io| io.puts commands }
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
    gnuplot( commands )
  end

  def serialize_plot( set_commands: nil, splot_commands: nil, frame_number: nil )
    frame_suffix = "_%04d" % frame_number if frame_number != nil
    commands = %Q(
      set terminal png size 4096,3072
      set output "tmp/#{@map_name}#{frame_suffix}.png"
      set zrange[150:650]
      set view 60, 130
      set xlabel "x"
      set ylabel "y"
      set style data lines
      set hidden3d
      #{set_commands}
      splot 'tmp/#{@map_name}_grid_data.dat' u 1:2:3 w lines#{splot_commands}
      # w pm3d -> isolines heat map
    )
    gnuplot( commands )
  end

  def serialize( agent_path_data: nil, animate: false )
    serialize_grid
    start_marker = nil
    end_marker = nil
    if agent_path_data != nil
      File.open( "tmp/agent_path.dat", 'w') { |file| file.write( agent_path_data.join( "\n" ) ) }
      start_marker_xyz = agent_path_data[0].split( " " ).join( "," )
      end_marker_xyz = agent_path_data[-1].split( " " ).join( "," )
      set_start_marker = "      set object circle at #{start_marker_xyz} size 0.5 fc rgb '#2222ff' fs solid 1.0"
      set_end_marker = "      set object circle at #{end_marker_xyz} size 0.5 fc rgb '#22ff22' fs solid 1.0"
    end
    last_frame_index = nil
    if animate && agent_path_data != nil
      last_frame_index = agent_path_data.length - 1
      serialize_first_frame( set_start_marker: set_start_marker )
      serialize_path_frames( last_frame_index: last_frame_index, set_start_marker: set_start_marker )
    end
    serialize_last_frame( last_frame_index: last_frame_index, set_start_marker: set_start_marker, set_end_marker: set_end_marker )
    # if animate && agent_path_data != nil
    #   os_map_name = @map_name.gsub( ' ', '\ ' )
    #   %x( apngasm tmp/#{os_map_name}_ani.png tmp/#{os_map_name}_*.png )
    # end
  end

  def serialize_first_frame( set_start_marker: nil )
    serialize_plot( set_commands: set_start_marker, frame_number: 1 )
  end

  def serialize_path_frames( last_frame_index: 0, set_start_marker: nil )
    (0..last_frame_index).each do |index|
      splot = ",\\\n            'tmp/agent_path.dat' u 1:2:3 every ::0::#{index} w lines lc rgb '#ff2222'"
      serialize_plot( set_commands: set_start_marker, splot_commands: splot,  frame_number: (index + 2) )
    end
  end

  def serialize_last_frame( last_frame_index: nil, set_start_marker: nil, set_end_marker: nil )
    set_commands = "#{ set_start_marker }\n#{ set_end_marker }"
    splot = ",\\\n            'tmp/agent_path.dat' u 1:2:3 w lines lc rgb '#ff2222'"
    last_frame_index += 3 if last_frame_index != nil
    serialize_plot( set_commands: set_commands, splot_commands: splot,  frame_number: last_frame_index )
  end

end
