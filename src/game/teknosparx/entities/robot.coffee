ig.module(
  "game.teknosparx.entities.robot"
).requires(
  "impact.animation"
  "impact.entity"
).defines () ->
  window.Robot = ig.Entity.extend(
    size: {x:16, y:16}
    animSheet: new ig.AnimationSheet("media/teknosparx/robot.png", 16, 16)

    init: (x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim("idle", 1.0, [0])
      this.addAnim("moveSouth", 0.1, [0,1])
      this.addAnim("moveNorth", 0.1, [2,3])
      this.addAnim("moveWest", 0.1, [4,5])
      this.addAnim("moveEast", 0.1, [6,7])
      this.currentAnim = this.anims.moveSouth

    update: () ->
      this.parent()
  )