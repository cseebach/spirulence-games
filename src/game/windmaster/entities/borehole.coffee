ig.module(
  "game.windmaster.entities.borehole"
).requires(
  'impact.game'
  'impact.animation'
  'game.windmaster.entities.placeable'
).defines ->
  window.Borehole = Placeable.extend(
    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    animSheet: new ig.AnimationSheet("media/windmaster/borehole.png", 16, 16)

    energyConsumed: 20

    productionCost: 200

    mineralsProduced: 20

    name: "Asthenosphere Borehole"

    init:(x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim("idle", 0.2, [0,0,0,1,2,3,4,4,3,2,1,0,0,0])

    getMineralsProduced:()->
      mines = (mine for mine in ig.game.getEntitiesByType(Mine) when mine.placed)
      mineralsProduced = this.mineralsProduced
      mineralsProduced += 5 for mine in mines when mine.distanceTo(this) < 30
      return mineralsProduced
  )