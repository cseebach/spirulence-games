ig.module(
  'game.main'
)
.requires(
  'impact.game'
  'impact.font'
)
.defines(() ->

  Placeable = ig.Entity.extend(
    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    mineralsCost: 0

    energyCost: 0

    init:(x, y, settings) ->
      this.parent(x, y, settings)

    canPlace:()->
      if this.mineralsCost >  ig.game.mineralsProduced - ig.game.mineralsConsumed
        return false
      if this.energyCost >  ig.game.energyProduced - ig.game.energyConsumed
        return false
      return true

    place:()->
      ig.game.mineralsConsumed += this.mineralsCost
      ig.game.energyConsumed += this.energyCost
  )

  DomeGenerator = Placeable.extend(
    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    animSheet: new ig.AnimationSheet("media/dome_generator.png", 16, 16)

    energyCost: 800

    init:(x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim("idle", 0.05, [0,1,2,3,4,5,6,7])
  )

  QuantomOptoComptroller = Placeable.extend(
    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    animSheet: new ig.AnimationSheet("media/qo_comptroller.png", 16, 16)

    energyCost: 20

    init:(x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim("idle", 0.2, [0,1,2,3,])

    #place: () ->

  )

  Supercollider = Placeable.extend(
    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    animSheet: new ig.AnimationSheet("media/supercollider.png", 16, 16)

    energyCost: 50

    init:(x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim("idle", 0.1, [0,0,0,0,0,0,0,0,0,1,2,3,4,5,6,7,8,9])

    #place: () ->

  )

  ResearchCenter = Placeable.extend(
    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    animSheet: new ig.AnimationSheet("media/research_center.png", 16, 16)

    energyCost: 10

    init:(x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim("idle", 0.1, [0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,4,4,3,2,1,0,0,0])

    #place: () ->

  )

  Borehole = Placeable.extend(
    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    animSheet: new ig.AnimationSheet("media/borehole.png", 16, 16)

    energyCost: 10

    init:(x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim("idle", 0.2, [0,0,0,1,2,3,4,4,3,2,1,0,0,0])

    place: () ->
      this.parent()
      ig.game.mineralsProduced += 30
  )

  Generator = Placeable.extend(

    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    animSheet: new ig.AnimationSheet('media/generator.png', 16, 16)
    #placeSheet: new ig.AnimationSheet('media/generator.png', 16, 16)

    init: (x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim('idle', 0.1, [0,1])

    place: () ->
      this.parent()
      ig.game.energyProduced += 4
  )

  Mine = Placeable.extend(
    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    animSheet: new ig.AnimationSheet("media/mine.png", 16 ,16)

    energyCost: 1

    init: (x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim('idle', 0.2, [0,1,2,3,4,4,4,4,4,4,4,3,2,1,0,0,0,0,0])

    place: () ->
      this.parent()
      ig.game.mineralsProduced += 3
  )

  Factory = Placeable.extend(
    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    animSheet: new ig.AnimationSheet("media/factory.png", 16 ,16)

    energyCost: 6
    mineralsCost: 6

    init: (x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim('idle', 0.4, [0,1])

    place: () ->
      this.parent()
      ig.game.production += 3
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

    init: (x, y, buildingClass, imagePath, buildCost, enabled) ->
      this.x = x
      this.y = y
      this.size = 16
      this.buildingClass = buildingClass
      this.image = new ig.Image(imagePath)
      this.enabled = if enabled? then enabled else true
      this.hovered = false
      this.buildCost = buildCost
      this.numberBuilt = 0

    update: ()->
      if this.x < ig.input.mouse.x < this.x + this.size and this.y < ig.input.mouse.y < this.y + this.size and this.enabled
        this.hovered = true
        if ig.input.released("secondary_button")
          ig.game.buildQueue.add(this)
        if ig.input.released("primary_button")
          if this.numberBuilt > 0
            ig.game.updatePlaceEntity(this.buildingClass, this)
      else
        this.hovered = false

    productionFinished: () ->
      this.numberBuilt += 1

    buildingBuilt: () ->
      this.numberBuilt -= 1
      if this.numberBuilt <= 0
        ig.game.updatePlaceEntity(false, this)

    draw: ()->
      if this.hovered
        this.buttonBack.drawTile(this.x, this.y, 1, this.size)
      else
        this.buttonBack.drawTile(this.x, this.y, 0, this.size)
      this.image.drawTile(this.x, this.y, 0, this.size)
      if not this.enabled
        this.buttonBack.drawTile(this.x, this.y, 1, this.size)

      ig.game.font.draw(this.numberBuilt.toString(), this.x, this.y-6)

  )

  BuildQueue = ig.Class.extend(

    queueBack: new ig.Image("media/queue_button.png")

    init: (x, y) ->
      this.x = x
      this.y = y
      this.tileSize = 16
      this.queue = []
      this.costCompleted = 0

    add: (buildButton) ->
      this.queue.push(buildButton)

    update:() ->
      if this.queue.length > 0
        this.costCompleted += ig.game.production / 60.0
        if this.costCompleted >= this.queue[0].buildCost
          this.queue[0].productionFinished()
          this.queue.shift()
          this.costCompleted = 0

    getPercentDone:()->
      return if this.costCompleted > 0.0 then this.costCompleted*16.0/this.queue[0].buildCost else 0.1

    drawQueueItem: (button, i) ->
      this.queueBack.drawTile(this.x + i*16, this.y, 0, this.tileSize)
      button.image.drawTile(this.x + i*16, this.y, 0, this.tileSize)
      if i == 0
        this.queueBack.draw(this.x, this.y-6,
          32, 0,
          this.getPercentDone(), 6)

    draw: () ->
       this.drawQueueItem(button, i) for button, i in this.queue
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
      this.updatePlaceEntity(false)

      this.buildButtons = [
        new BuildingButton(61, 224, Mine, "media/mine.png", 40)
        new BuildingButton(77, 224, Generator, "media/generator.png", 40)
        new BuildingButton(93, 224, Factory, "media/factory.png", 100)
        new BuildingButton(113, 224, ResearchCenter, "media/research_center.png", 200)
        new BuildingButton(129, 224, Borehole, "media/borehole.png", 1000, false)
        new BuildingButton(145, 224, Supercollider, "media/supercollider.png", 2000, false)
        new BuildingButton(161, 224, QuantomOptoComptroller, "media/qo_comptroller.png", 2000, false)
        new BuildingButton(177, 224, DomeGenerator, "media/dome_generator.png", 5000, false)
      ]

      this.buildButtons[0].productionFinished()
      this.buildButtons[0].productionFinished()
      this.buildButtons[1].productionFinished()
      this.buildButtons[1].productionFinished()
      this.buildButtons[2].productionFinished()

      this.buildQueue = new BuildQueue(200, 224)

      this.energyProduced = 0
      this.energyConsumed = 0
      this.mineralsProduced = 0
      this.mineralsConsumed = 0
      this.production = 0

    updatePlaceEntity: (placeClass, buttonToUpdate) ->
      this.buttonToUpdate = buttonToUpdate
      this.placeClass = placeClass
      if this.placeEntity
        this.placeEntity.kill()
      if placeClass
        this.placeEntity = this.spawnEntity(this.placeClass, -100, -100)
        this.placeEntity.currentAnim.alpha = 0.5

    update: () ->
      # Update all entities and backgroundMaps
      this.parent();

      button.update() for button in this.buildButtons

      this.buildQueue.update()

      this.minerals += this.mineralsPerSecond/60.0

      placeX = Math.floor(ig.input.mouse.x/16)*16
      placeY = Math.floor(ig.input.mouse.y/16)*16

      # Add your own, additional update code here
      if ig.input.released("primary_button") and this.legalPlacement(placeX, placeY)
          if this.placeClass and this.placeEntity.canPlace()
            justPlaced = this.spawnEntity(this.placeClass, placeX, placeY)
            justPlaced.place()
            this.buttonToUpdate.buildingBuilt()
      else if this.placeEntity
        this.placeEntity.pos.x = placeX
        this.placeEntity.pos.y = placeY

    legalPlacement: (x, y)->
      if x < 64
        return y < 176
      else
        return y < 208

    draw: () ->
      # Draw all entities and backgroundMaps
      this.parent();

      # Add your own drawing code here
      # have to draw the UI here
      this.lowerPanelBg.draw(0, 209)

      this.font.draw("Build:", 61, 212)

      button.draw() for button in this.buildButtons

      this.buildQueue.draw()

      this.leftPanelBg.draw(0, 181)

      this.font.draw("Minerals:", 1, 185)
      this.font.draw(sprintf(
        "%.0d-%.0d=%+.0d",
        this.mineralsProduced,
        this.mineralsConsumed,
        this.mineralsProduced - this.mineralsConsumed
      ), 1, 193)

      this.font.draw("Energy:", 1, 205)
      this.font.draw(sprintf(
        "%.0d-%.0d=%+.0d",
        this.energyProduced,
        this.energyConsumed,
        this.energyProduced - this.energyConsumed
      ), 1, 213)

      this.font.draw("Production:", 1, 225)
      this.font.draw(sprintf("%+.0d", this.production), 1, 233)
  )

  # Start the Game with 60fps, a resolution of 320x240, scaled
  # up by a factor of 2
  ig.main( '#canvas', MyGame, 60, 320, 240, 2 )
)