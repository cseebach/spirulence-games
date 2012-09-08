ig.module(
  'game.windmaster.entities.supercollider'
).requires(
  'impact.game'
  'game.windmaster.entities.placeable'
).defines ->
  window.Supercollider = Placeable.extend(
    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    animSheet: new ig.AnimationSheet("media/windmaster/supercollider.png", 16, 16)

    research: 30

    energyConsumed: 50

    productionCost: 1000

    name: "Supercollider"

    init:(x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim("idle", 0.1, [0,0,0,0,0,0,0,0,0,1,2,3,4,5,6,7,8,9])

    getResearch:() ->
      researchCenters = (center for center in ig.game.getEntitiesByType(ResearchCenter) when center.placed)
      research = this.research
      research += 10 for center in researchCenters when center.distanceTo(this) < 30
      return research
  )