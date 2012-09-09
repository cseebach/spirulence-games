ig.module(
  "game.teknosparx.main"
).requires(
  "impact.game"
  "game.teknosparx.levels.world"
  "game.teknosparx.entities.robot"
).defines(() ->


  Teknosparx = ig.Game.extend(

    #HUD graphics
    panelBg: new ig.Image("media/teknosparx/tekno_bg.png")

    init:()->
      ig.input.bind(ig.KEY.MOUSE1, "primary_button")

      ig.game.loadLevel(LevelWorld)

      ig.game.spawnEntity(Robot, 80, 160)

    update:()->
      this.parent()

      if ig.input.pressed("primary_button")
        this.enterDragState()

      if ig.input.released("primary_button")
        this.exitDragState()

      if this.dragState
        ig.game.screen.x = this.firstScreenX + (this.firstMouseDragX - ig.input.mouse.x)
        ig.game.screen.y = this.firstScreenY + (this.firstMouseDragY - ig.input.mouse.y)

        ig.game.screen.x = ig.game.screen.x.limit(0, (75-20)*16)
        ig.game.screen.y = ig.game.screen.y.limit(0, (50-15)*16)

    enterDragState: () ->
      this.firstMouseDragX = ig.input.mouse.x
      this.firstMouseDragY = ig.input.mouse.y
      this.firstScreenX = ig.game.screen.x
      this.firstScreenY = ig.game.screen.y
      this.dragState = true

    exitDragState: ()->
      this.dragState = false

    draw:()->
      this.parent()

      this.panelBg.draw(0,220)
  )

  ig.main( '#canvas', Teknosparx, 60, 320, 240, 2 )
)