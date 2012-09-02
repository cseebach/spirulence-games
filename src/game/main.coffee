ig.module(
  'game.main'
)
.requires(
  'impact.game'
  'impact.font'
)
.defines(() ->

  DomeGenerator = ig.Entity.extend(
    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    animSheet: new ig.AnimationSheet("media/dome_generator.png", 16, 16)

    init:(x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim("idle", 0.05, [0,1,2,3,4,5,6,7])

    place: () ->

  )

  QuantomOptoComptroller = ig.Entity.extend(
    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    animSheet: new ig.AnimationSheet("media/qo_comptroller.png", 16, 16)

    init:(x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim("idle", 0.2, [0,1,2,3,])

    place: () ->

  )

  Supercollider = ig.Entity.extend(
    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    animSheet: new ig.AnimationSheet("media/supercollider.png", 16, 16)

    init:(x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim("idle", 0.1, [0,0,0,0,0,0,0,0,0,1,2,3,4,5,6,7,8,9])

    place: () ->

  )

  ResearchCenter = ig.Entity.extend(
    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    animSheet: new ig.AnimationSheet("media/research_center.png", 16, 16)

    init:(x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim("idle", 0.1, [0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,4,4,3,2,1,0,0,0])

    place: () ->

  )

  Borehole = ig.Entity.extend(
    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    animSheet: new ig.AnimationSheet("media/borehole.png", 16, 16)

    init:(x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim("idle", 0.2, [0,0,0,1,2,3,4,4,3,2,1,0,0,0])


    place: () ->
  )

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

  BuildingButton = ig.Class.extend(

    buttonBack: new ig.Image("media/button.png")

    init: (x, y, buildingClass, imagePath, enabled) ->
      this.x = x
      this.y = y
      this.size = 16
      this.buildingClass = buildingClass
      this.image = new ig.Image(imagePath)
      this.enabled = if enabled? then enabled else true

    update: ()->

    draw: ()->
      this.buttonBack.drawTile(this.x, this.y, 0, this.size)
      this.image.drawTile(this.x, this.y, 0, this.size)
      if not this.enabled
        this.buttonBack.drawTile(this.x, this.y, 0, this.size)

  )

  Queue = ig.Class.extend(

    init: (x, y) ->
      this.x = x
      this.y = y
      this.tileSize = 16
      this.queue = []


  )

  MyGame = ig.Game.extend(

    # Load a font
    font: new ig.Font( 'media/04b03.font.png' )

    # HUD graphics
    leftPanelBg: new ig.Image("media/left_panel.png")
    lowerPanelBg: new ig.Image("media/lower_panel.png")

    init: () ->
      # Initialize your game here; bind keys etc.
      ig.input.bind(ig.KEY.MOUSE1, 'primary_button')
      ig.input.bind(ig.KEY.MOUSE2, 'secondary_button')
      ig.input.bind(ig.KEY.F, 'factory_placement')
      ig.input.bind(ig.KEY.M, 'mine_placement')
      ig.input.bind(ig.KEY.G, 'generator_placement')
      ig.input.bind(ig.KEY.B, 'borehole_placement')
      ig.input.bind(ig.KEY.R, 'research_placement')
      ig.input.bind(ig.KEY.S, 'supercollider_placement')
      ig.input.bind(ig.KEY.Q, 'qoc_placement')
      ig.input.bind(ig.KEY.D, 'dome_placement')

      this.spawnEntity(BackGround, 0, 0)
      this.updatePlaceEntity(Factory)

      this.buildButtons = [
        new BuildingButton(61, 224, Mine, "media/mine.png")
        new BuildingButton(77, 224, Generator, "media/generator.png")
        new BuildingButton(93, 224, Factory, "media/factory.png")
        new BuildingButton(113, 224, ResearchCenter, "media/research_center.png")
        new BuildingButton(129, 224, Borehole, "media/borehole.png", false)
        new BuildingButton(145, 224, Supercollider, "media/supercollider.png", false)
        new BuildingButton(161, 224, QuantomOptoComptroller, "media/qo_comptroller.png", false)
        new BuildingButton(177, 224, DomeGenerator, "media/dome_generator.png", false)
      ]

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

      button.update() for button in this.buildButtons

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

    draw: () ->
      # Draw all entities and backgroundMaps
      this.parent();

      # Add your own drawing code here
      # have to draw the UI here
      this.lowerPanelBg.draw(0, 209)

      this.font.draw("Build:", 61, 215)

      button.draw() for button in this.buildButtons




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