# Courtesy https://github.com/tonyc/ruby-plasma-fractal

class PlasmaFractal
  DEFAULT_SIZE = 9
  DEFAULT_HEIGHT_SEED = 100

  attr_reader :size, :height_seed, :data

  def initialize( size:, height_seed: )
    @size = size || DEFAULT_SIZE
    raise ArgumentError, "Size must be an integer power of two, plus one (n^^2 + 1), and greater than 1" if size < 2 || !valid_size?

    @height_seed = height_seed || DEFAULT_HEIGHT_SEED

    @data = Array.new( size, 0.0 )
    @data.map! { |d| Array.new( size, 0.0 ) }

    @data[0][0] = @data[0][size-1] = @data[size-1][0] = @data[size-1][size-1] = height_seed
    generate!
  end

  def generate!
    h = @height_seed / 2

    side_length = size - 1

    while (side_length >= 2) do
      half_side = side_length / 2

      x = 0
      while (x < size - 1) do

        y = 0
        while (y < size - 1) do
          c1 = @data[x][y]
          c2 = @data[x+side_length][y]
          c3 = @data[x][y+side_length]
          c4 = @data[x+side_length][y+side_length]

          avg = (c1 + c2 + c3 + c4) / 4.0
          avg = avg + (rand()*2*h) - h

          set_cell x+half_side, y+half_side, avg

          y = y + side_length
        end

        x = x + side_length
      end

      # diamond step
      (0...size-1).step(half_side) do |x|
        (((x+half_side)%side_length)...(size-1)).step(side_length) do |y|
          c1 = @data[(x-half_side+size-1) % (size-1)][y]
          c2 = @data[(x + half_side)% (size-1)][y]
          c3 = @data[x][(y + half_side) % (size-1)]
          c4 = @data[x][(y - half_side + (size-1)) % (size-1)]

          avg = (c1 + c2 + c3 + c4) / 4.0
          avg = avg + (rand()*2*h) - h

          set_cell(x, y, avg)

          set_cell(size-1, y, avg) if x == 0
          set_cell(x, size-1, avg) if y == 0
        end
      end

      side_length = side_length / 2
      h = h / 2.0
    end
  end

  def set_cell(x, y, val)
    @data[x][y] = val.to_f
  end

  def display_height_map
    @data.each do |row|
      row.each do |v|
        print v.to_i.to_s.rjust(8)
      end
      puts
    end
  end

  # def crop_data( crop: 0 )
  #   crop_end = @data.length - 1 - crop
  #   data = @data[crop..crop_end]
  #   data.map! { |slice| slice[crop..crop_end] }
  # end
  #
  # def get_xyz_map( crop: 0 )
  #   data = crop_data( crop: crop )
  #   puts( "x: #{data.length}, y: #{data[0].length}" )
  #   map = ""
  #   data.each_with_index do | row, y_index |
  #     row.each_with_index do | v, x_index |
  #       map << "#{x_index}\t#{y_index}\t#{v.to_i}\n"
  #     end
  #   end
  #   map
  # end

  protected
  def valid_size?
    # There has to be a better way to do this...
    log_2_size = Math.log(@size - 1) / Math.log(2)
    log_2_size.to_i == log_2_size
  end

end
