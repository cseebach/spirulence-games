ig.module(
  'game.windmaster.entities.quantopto'
).requires(
  'impact.game'
  'game.windmaster.entities.placeable'
).defines ->
  window.QuantomOptoComptroller = Placeable.extend(
    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    animSheet: new ig.AnimationSheet("media/windmaster/qo_comptroller.png", 16, 16)

    energyConsumed: 10

    productionCost: 1000

    name: "Quantum-Optical Comptroller"

    init:(x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim("idle", 0.2, [0,1,2,3,])

    getEnergyProduced: () ->
      generators = (generator for generator in ig.game.getEntitiesByType(Generator) when generator.placed)
      energyProduced = 0
      energyProduced += 5 for generator in generators when generator.distanceTo(this) < 30
      return energyProduced
  )