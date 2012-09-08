ig.module(
  "game.windmaster.entities.factory"
).requires(
  'impact.game'
  'impact.animation'
  'game.windmaster.entities.placeable'
).defines ->
  window.Factory = Placeable.extend(
    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    animSheet: new ig.AnimationSheet("media/windmaster/factory.png", 16 ,16)

    name: "Factory"

    energyConsumed: 6
    mineralsConsumed: 6
    productionProduced: 3
    productionCost: 100

    init: (x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim('idle', 0.4, [0,1])
  )