ig.module(
  'game.windmaster.entities.domegen'
).requires(
  'impact.game'
  'game.windmaster.entities.placeable'
).defines ->
  window.DomeGenerator = Placeable.extend(
    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    animSheet: new ig.AnimationSheet("media/windmaster/dome_generator.png", 16, 16)

    energyConsumed: 100

    productionCost: 3000

    name: "Dome Generator"

    init:(x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim("idle", 0.05, [0,1,2,3,4,5,6,7])

    place:()->
      this.parent()
      generators = ig.game.getEntitiesByType(DomeGenerator)
      numGenerators = generators.length
      if ig.game.placeEntity in generators
        numGenerators -= 1

      if numGenerators >= 4
        ig.game.winning = true
        ig.game.winCondition = "generators"
  )