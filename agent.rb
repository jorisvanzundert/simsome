class Agent

  attr_reader :name, :x, :y

  def initialize( name: nil, x: 0, y: 0 )
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
  end

  def estimate_effort( tile_height: 0 )
    # Here: what do I base my choices on? You can not *see* the actual level/capacity/effort a step will take, but you can see if a tile in any direction is higher or lowere, and you can estimate. Estimates are {REF} by rule of thumb between 0.25$% and 400% accurate. At first we can base this on chance I guess, but experience let's you be a bit more accurate.
    ( 0.25 + rand * 3.75 ) * tile_height
  end

  def decide( landscape: nil, tile_height: 0, capacity: 0 )
    # An agent at each turn is having to make a choice: what direction to research? How does he make this choice?
    # The playing fiel/landscape is made up of square tiles. In the original experiment {REF} a tile's height indicates its 'epistemological value'. The delta between two tiles indicates the epistemological or research effort that is needed to pass to the higher tile. Choice is not necessarily based on having enough effort (capacity) available. Researchers make wrong choices all the time. So they may choose to bite of too large a chunk, while being right about the direction. They may spent their capacity in a erroneous, wrong, or fallable way and therefore may fail to reach the higher level. But this is pertaining to effect/success, so this goes somewhere else.
    # Given a choice of efforts that he/se may match with capabilities, what choice does a researcher make? If the researher can proceed to 0.5 or 0.8 having 1.0, what is chosen, how? What if there are 2 tiles of 0.3, and capacity is 0.8? Does the researcher pursue both? You can not split yourself, but you can split capacity (teams), but you may lose skills that way in your own team. This is nice to model out, but later.
    # I guess the choice again has to do with propensities: the inclination to put your apples in one basket or not, the ability to 'let go' of a team.
    # Let's go with a conservative attitude for now: the researcher picks the tile that has a the lowest value that is still higher than his own. Also: A researcher never goes back to work just done, so the tile that he just came from should be excluded. (We ignore this for now) However, a researcher may wrongly estimate another tile as higher while it is in reality lower (and can be work done already).

    # scout_surrounding_tiles[] = get_surrounding_tiles()
    # efforts[] = surrounding_tiles.map effort with estimates
    # efforts.reject! ( effort < current_level )
    # choice = efforst.min

    estimates = {}
    landscape.adjacent_heights( x: @x, y: @y ).directions_and_heights do |direction, height|
      # ignores 'impossible' directions, i.e. off the map (nil)
      estimates[ direction ] = estimate_effort( tile_height: height ) if height != nil
    end
    estimates = estimates.sort_by { |key, value| value }.to_h
    puts estimates
    return "Hello World!"
  end

end
