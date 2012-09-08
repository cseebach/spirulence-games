ig.module(
  "game.windmaster.entities.mine"
).requires(
  'impact.game'
  'impact.animation'
  'game.windmaster.entities.placeable'
  'game.windmaster.techs'
).defines ->
  window.Mine = Placeable.extend(
    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    animSheet: new ig.AnimationSheet("media/windmaster/mine.png", 16 ,16)

    name: "Mine"

    energyConsumed: 2
    mineralsProduced: 3
    productionCost: 40

    init: (x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim('idle', 0.2, [0,1,2,3,4,4,4,4,4,4,4,3,2,1,0,0,0,0,0])

    getMineralsProduced:()->
      mineralsProduced = this.mineralsProduced
      if techs.advRobotics.researched
        mineralsProduced += 1
      if techs.extremeRobotics.researched
        mineralsProduced += 1
      return mineralsProduced
  )