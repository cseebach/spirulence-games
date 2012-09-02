ig.module(
  'game.main'
)
.requires(
  'impact.game'
  #'impact.font'
)
.defines(() ->

  Generator = ig.Entity.extend(

    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    animSheet: new ig.AnimationSheet('media/generator.png', 16, 16)
    #placeSheet: new ig.AnimationSheet('media/generator.png', 16, 16)

    init: (x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim('idle', 0.1, [0,1])

    place: () ->
      ig.game.totalEnergy += 10
  )

  Mine = ig.Entity.extend(
    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    animSheet: new ig.AnimationSheet("media/mine.png", 16 ,16)

    init: (x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim('idle', 0.2, [0,1,2,3,4,4,4,4,4,4,4,3,2,1,0,0,0,0,0])

    place: () ->
      ig.game.mineralsPerSecond += 3


  )

  Factory = ig.Entity.extend(
    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    animSheet: new ig.AnimationSheet("media/factory.png", 16 ,16)

    init: (x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim('idle', 0.4, [0,1])

    place: () ->
      ig.game.mineralsPerSecond -= 3
  )

  BackGround = ig.Entity.extend(

    size: {x:320, y:240}
    zIndex: 50
    animSheet: new ig.AnimationSheet("media/background.png", 320, 240)

    init: (x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim('idle', 0.1, [0])
  )

  MyGame = ig.Game.extend(

    # Load a font
    font: new ig.Font( 'media/04b03.font.png' )

    # HUD graphics
    leftPanelBg: new ig.Image("media/left_panel.png")

    init: () ->
      # Initialize your game here; bind keys etc.
      ig.input.bind(ig.KEY.MOUSE1, 'place_building')
      ig.input.bind(ig.KEY.F, 'factory_placement')
      ig.input.bind(ig.KEY.M, 'mine_placement')
      ig.input.bind(ig.KEY.G, 'generator_placement')

      this.spawnEntity(BackGround, 0, 0)
      this.updatePlaceEntity(Factory)

      this.totalEnergy = 20
      this.usedEnergy = 10
      this.minerals = 100
      this.mineralsPerSecond = 0

    updatePlaceEntity: (placeClass) ->
      this.placeClass = placeClass
      if this.placeEntity
        this.placeEntity.kill()
      this.placeEntity = this.spawnEntity(this.placeClass, -100, -100)
      this.placeEntity.currentAnim.alpha = 0.5

    update: () ->
      # Update all entities and backgroundMaps
      this.parent();

      this.minerals += this.mineralsPerSecond/60.0

      placeX = Math.floor(ig.input.mouse.x/16)*16
      placeY = Math.floor(ig.input.mouse.y/16)*16

      # Add your own, additional update code here
      if ig.input.released("place_building")
        justPlaced = this.spawnEntity(this.placeClass, placeX, placeY)
        justPlaced.place()
      else
        this.placeEntity.pos.x = placeX
        this.placeEntity.pos.y = placeY

      if ig.input.released("factory_placement")
        this.updatePlaceEntity(Factory)

      if ig.input.released("mine_placement")
        this.updatePlaceEntity(Mine)

      if ig.input.released("generator_placement")
        this.updatePlaceEntity(Generator)

    draw: () ->
      # Draw all entities and backgroundMaps
      this.parent();

      # Add your own drawing code here
      # have to draw the UI here
      this.leftPanelBg.draw(0, 181)

      this.font.draw("Minerals:", 1, 185)
      this.font.draw(sprintf("%.0d (%+.0d)", this.minerals, this.mineralsPerSecond), 1, 193)

      this.font.draw("Energy Used:", 1, 205)
      this.font.draw(sprintf("%.0d/%.0d", this.usedEnergy, this.totalEnergy), 1, 213)
  )

  # Start the Game with 60fps, a resolution of 320x240, scaled
  # up by a factor of 2
  ig.main( '#canvas', MyGame, 60, 320, 240, 2 )
)