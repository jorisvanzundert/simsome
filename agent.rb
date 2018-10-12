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
    # Researchers don't see or know actual value or epistemological gain of a next level, they only can estimate.
    # Estimates can be as wrong from 0.25% of reality to 400% of said reality.
    estimates = survey_heights.map { |direction, height| [ direction, estimate_effort( tile_height: height ) ] }.to_h
    # next assumes a researcher only invests in directions that will 'up' his level
    # 20181011_1320: You cannot do this, it results in deadlock in the case of a local optimum. In that case the only directions are down (less than 0) and ''estimates'' turns out nil. How do we solve this?
    # * Possibility 1: Researcher that reaches a top, changes subject (i.e. gets parachuted somewhere else in the landscape)?
    # * Possibility 2: 'Deinvest', accept a lower episteological gain to explore new directions. Problem: how long to get out of local optimum? Maybe at least as long as the path was you took to this local optimum?
    # This problem also inspires thoughts about the epistemological landscape itself. It was random until now. But in practice a researcher is very seldom really done with a subject, there's always more to learn it seems. Subjects change because of this, but not radically mostly. Does this mean that the landscape as a whole needs  a direction of ever increasing epistemological value? Isn't that way too deterministic?
    # * Possibility 3 (or maybe 2.5): you look for low ground in the vicinity in another direction. Equivalent to a researcher surmizing "What directions aren't researched much yet?" This requires I think a more sophisticated approach with an agent that has a sense of direction and doesn't budge at the first downgrade encountered. Only when time and time again the direction is down the researcher will change directions decidedly.
    estimates = estimates.select  { |direction, estimate| estimate > 0 }
    estimates = estimates.sort_by { |direction, estimate| estimate }.to_h
    # researchers choose the tile that offers the smallest increase in height. That is: they are conservative in spenditure but expext a gain.
    [ :direction, :estimate ].zip( estimates.find { |direction, estimate| estimate > 0 } ).to_h
  end

  def move( direction: )
    self.send "move_#{direction}"
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
