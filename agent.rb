class Agent

  attr_reader :name, :x, :y

  def initialize( name: nil, x: 0, y: 0, landscape: nil )
    # Instance variables
    # What would these be in case of a agent?
    # Propensities I guess, but for what?
    #   Collaboration preparedness
    #   Fun/Satisfaction (goes up with rewards)
    #   Status
    #   Sheer cleverness
    #   Communication skills
    #   Persuasiveness (getting other to do what you need them to do)
    #   Credulity (how much you are prepared to be persuaded, how influentiable you are)
    #   Clarity of aim
    #   Work (how many hours on average you put in)
    @name = name
    @x = x
    @y = y
    @landscape = landscape
  end

  def estimate_effort( tile_height: 0 )
    # Here: what do I base my choices on? You can not *see* the actual level/capacity/effort a step will take, but you can see if a tile in any direction is higher or lowere, and you can estimate. Estimates are {REF} by rule of thumb between 0.25$% and 400% accurate. At first we can base this on chance I guess, but experience let's you be a bit more accurate.
    ( 0.25 + rand * 3.75 ) * tile_height
  end

  def decide
    # An agent at each turn is having to make a choice: what direction to research? How does he make this choice?
    # The playing fiel/landscape is made up of square tiles. In the original experiment {REF} a tile's height indicates its 'epistemological value'. The delta between two tiles indicates the epistemological or research effort that is needed to pass to the higher tile. Choice is not necessarily based on having enough effort (capacity) available. Researchers make wrong choices all the time. So they may choose to bite of too large a chunk, while being right about the direction. They may spent their capacity in a erroneous, wrong, or fallable way and therefore may fail to reach the higher level. But this is pertaining to effect/success, so this goes somewhere else.
    # Given a choice of efforts that he/se may match with capabilities, what choice does a researcher make? If the researher can proceed to 0.5 or 0.8 having 1.0, what is chosen, how? What if there are 2 tiles of 0.3, and capacity is 0.8? Does the researcher pursue both? You can not split yourself, but you can split capacity (teams), but you may lose skills that way in your own team. This is nice to model out, but later.
    # I guess the choice again has to do with propensities: the inclination to put your apples in one basket or not, the ability to 'let go' of a team.
    # Let's go with a conservative attitude for now: the researcher picks the tile that has a the lowest value that is still higher than his own. Also: A researcher never goes back to work just done, so the tile that he just came from should be excluded. (We ignore this for now) However, a researcher may wrongly estimate another tile as higher while it is in reality lower (and can be work done already).
    # For a first implementation we also ignore the capacity bit and just let the researcher move towards the next tile that in his/her estimate is least higher than the current height.

    # We ignore 'impossible' directions, i.e. off the map (nil). In a next version the world may be a sphere, but for now it is flat and we don't want our researchers to plummet from the edge.
    survey_heights = @landscape.survey_heights( x: @x, y: @y ).select { |direction, height| height != nil }
    current_height = survey_heights.delete( :center )
    # Researchers don't see or know actual value or epistemological gain of a next level, they only can estimate.
    # Estimates can be as wrong from 0.25% of reality to 400% of said reality.
    estimates = survey_heights.map { |direction, height| [ direction, estimate_effort( tile_height: height ) ] }.to_h
    # next assumes a researcher only invests in directions that will 'up' his level
    estimates = estimates.select  { |direction, estimate| estimate > current_height }
    estimates = estimates.sort_by { |direction, estimate| estimate }.to_h
    # researchers choose the tile that offers the smallest increase in height. That is: they are conservative in spenditure but expext a gain.
    [ :direction, :estimate ].zip( estimates.find { |direction, estimate| estimate > current_height } ).to_h
  end

  def move( direction: :center )
    self.send "move_#{direction}"
  end

  def move_center
  end

  def move_north
    @y -= 1
  end

  def move_north_east
    @x += 1
    @y -= 1
  end

  def move_east
    @x += 1
  end

  def move_south_east
    @x += 1
    @y += 1
  end

  def move_south
    @y += 1
  end

  def move_south_west
    @x -= 1
    @y += 1
  end

  def move_west
    @x -= 1
  end

  def move_north_west
    @x -= 1
    @y -= 1
  end

end
