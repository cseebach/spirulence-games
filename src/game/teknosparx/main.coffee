ig.module(
  "game.teknosparx.main"
).requires(
  "impact.game"
  "game.teknosparx.levels.world"
).defines(() ->


  Teknosparx = ig.Game.extend(
    init:()->
      ig.game.loadLevel(LevelWorld)

    update:()->
      this.parent()

    draw:()->
      this.parent()
  )

  ig.main( '#canvas', Teknosparx, 60, 320, 240, 2 )
)