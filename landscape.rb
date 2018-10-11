require_relative 'plasma_fractal'

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

  def gnuplot(commands)
    IO.popen("gnuplot", "w") { |io| io.puts commands }
  end

  def serialize( agent_path_data: nil )
    if agent_path_data != nil
      File.open( "tmp/agent_path.dat", 'w') { |file| file.write( agent_path_data ) }
    end
    File.open( "tmp/#{@map_name}.dat", 'w') { |file| file.write( self.xyz_map ) }
    commands = %Q(
      set table "tmp/#{@map_name}_grid_data.dat"
      set dgrid3d 50,50 gauss 4
      splot "tmp/#{@map_name}.dat" u 1:2:3
      unset table
      unset dgrid3d
      set terminal png size 4096,3072
      set output "tmp/#{@map_name}.png"
      set zrange[150:650]
      set view 60, 130
      set xlabel "x"
      set ylabel "y"
      set style data lines
      set hidden3d
      splot 'tmp/#{@map_name}_grid_data.dat' u 1:2:3 w lines,\
            'tmp/agent_path.dat' u 1:2:3 w lines lc rgb '#ff2222',\
            'tmp/agent_path_start.dat' u 1:2:3 w points pointtype 7 lc rgb '#22ff22',\
            'tmp/agent_path_end.dat' u 1:2:3 w points pointtype 7 lc rgb '#2222ff'
      # w pm3d -> isolines heat map
    )
    gnuplot(commands)
  end

end
