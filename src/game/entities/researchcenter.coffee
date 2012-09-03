ig.module(
  'game.entities.researchcenter'
).requires(
  'impact.game'
  'impact.animation'
  'game.entities.placeable'
).defines ->
  window.ResearchCenter = Placeable.extend(
    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    animSheet: new ig.AnimationSheet("media/research_center.png", 16, 16)

    energyConsumed: 10

    research: 10

    productionCost: 100

    name: "Research Center"

    init:(x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim("idle", 0.1, [0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,4,4,3,2,1,0,0,0])
  )