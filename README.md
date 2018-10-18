# Simsome

Simsome is a project in its initial stages to try to simulate the interaction between software engineers and textual scholars. It was inspired by an article of Michael Weisberg and Ryan Muldoon, "Epistemic Landscapes and the Division of Cognitive Labor" (2009). This project wants to be rather critical of Weisberg and Muldoon's. As [tweeted](https://twitter.com/brandaen/status/1047882860936482817) I rather think what one is proving with any simulation model is one's own biasses. However, this project also wants to celebrate and explore the mostly untrodden potential of STS simulation runs focusing on humanities work. The intent is to see if a plausible model can be found for the love-hate relationship that exists between the humanities and digital c.q. computational methods and technologies.

For now there is only a vey basic framework for simulation. The objects available consist of a epistemic landscape (height is a measure of 'epistemic value'). The landscape is a randomly generated so called [fractal landscape](https://en.wikipedia.org/wiki/Fractal_landscape). More specifically an implementation of the [Diamond-sqaure algorithm](https://en.wikipedia.org/wiki/Diamond-square_algorithm) is used (courtesy https://github.com/tonyc/ruby-plasma-fractal). Some parameters can be tweaked: size as any power of 2, plus one; height seed.

The random map provides an epistemic landscape for an agent to find his way through. Essentially the goal of the agent is to move towards higher ground (representing more epistemic value). I have just started out modelling how the agent decides to move where. For now there are mostly a lot of thoughts (see code comments in `landscape.rb` and `agent.rb`) on how this may happen. The actual algorithm for now models conservative choice: the agent wants to spend as little effort as possible and prefers each step to move to higher grounds. In case of a local optimum the least 'epistemic loss' is chosen to move away from the optimum again. Quite logically this still results in much semi-deadlocks where an agent will endlessly circle some local optimum. As said: I am only in the initial stages of modelling this.

## Installing
Is cloning for now…

```
git clone https://github.com/jorisvanzundert/simsome.git
```

Important: also make sure that you have a `/tmp` and `/data_store` directory in the directory where you drop the code.

## Requirements

* gnuplot (http://www.gnuplot.info/)
* ffmpeg (https://www.ffmpeg.org/)

No, it really won't work without these. They should be callable from the command line/terminal with `gnuplot` and `ffmpeg`, so make sure you do not install just some GUI version (although most all of those will also install the command line versions, I think).

## Usage

Look at `simulate.rb` to get yourself going. Basically you create a `landscape`:

```
landscape = Landscape.new( name: 'Foobar World' )
```

and an agent to put in the landscape:

```
agent = Agent.new( name: 'Peter Abelard', x: 50, y: 50, landscape:  landscape )
```

Then have the agent decide to move any number of times, e.g.:

```
300.times{ agent.move( :direction = agent.decide[ :direction ] }
```

`agent.decide()` returns a hash with `:direction` of the move (north, north_east, east, south_east, etc.) and the epistemic `:elevation` that the agent *estimated* would reach there. (Note that estimations may be off regarding the reality of the epistemic landscape, see `agent.estimate_effort`, because researchers are not always right when estimating—painful, but true.)

If you want to see what the agent was up to, do:

`landscape.visualize( :agent = agent )`

This will generate a nice `PNG` in the `tmp` folder. If you like animations add `:animate = true` to generate a `.mov` there. Generating animations takes a little longer obvious (a mere split second for a picture versus 56.135 seconds for an animation of 300 moves in a 129 by 129 landscape at 4096 by 3072 image resolution) but it is fun.

Remember to store your interesting simulation by `simulation_id = landscape.store( agent: your_agent )`. I am lazy and hardly run nil checks, so I'll happily safe an empty landscape for you, but you'll run into a no method for nil thingy when trying to reload it later with `landscape.new(); landscape.load( simulation_id )`. So better add in that agent.

## The Future
* I'll consider more nil checks where people may find them handy
* Multi agent simulation obviously
* Ongoing sophistication of the way agents take decisions
* Add agent roles
* Add agent interaction
* Argue that simulations are worse lies than statistics

--JZ_20181018_1252


### References

<span style="font-size: 80%;">Weisberg, M. and Muldoon, R. (2009) ‘Epistemic Landscapes and the Division of Cognitive Labor’, *Philosophy of Science*, 76(2), pp. 225–252. doi: 10.1086/644786.</span>
