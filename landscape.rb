require_relative 'plasma_fractal'
require_relative 'adjacent_heights'

class Landscape

  attr_reader :height_map

  def initialize( name: nil, size: 129, height_seed: 480 )
    @map_name = name || File.basename(__FILE__).split('.')[0]
    fractal = PlasmaFractal.new( size: size, height_seed: height_seed )
    fractal.generate!
    @height_map = fractal.data
  end

  def adjacent_heights( x:, y: )
    AdjacentHeights.new( landscape: @height_map, x: x, y: y )
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

  def serialize()  # Probably gets a parameter agents/agent_info
    File.open( "tmp/#{@map_name}.dat", 'w') { |file| file.write( self.xyz_map ) }
    commands = %Q(
      set table "tmp/#{@map_name}_grid_data.dat"
      set dgrid3d 50,50 gauss 4
      splot "tmp/#{@map_name}.dat" u 1:2:3
      unset table
      unset dgrid3d
      set terminal png size 1024,768
      set output "tmp/#{@map_name}.png"
      set zrange[250:600]
      set view 60, 130
      set xlabel "x"
      set ylabel "y"
      set style data lines
      set hidden3d
      splot 'tmp/#{@map_name}_grid_data.dat' u 1:2:3 w lines,\
            'tmp/thatsinglepoint.dat' u 1:2:3 w points pointtype 7 lc rgb '#ff2222'
      # w pm3d -> isolines heat map
    )
    gnuplot(commands)
  end

end
