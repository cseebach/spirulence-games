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

    mineralsConsumed: 0

    mineralsProduced: 0

    energyConsumed: 0

    energyProduced: 0

    productionProduced: 0

    productionCost: 0

    research: 0

    placed: false

    init:(x, y, settings) ->
      this.parent(x, y, settings)

    canPlace:()->
      if this.getMineralsConsumed() >  ig.game.mineralsProduced - ig.game.mineralsConsumed
        return false
      if this.getEnergyConsumed() >  ig.game.energyProduced - ig.game.energyConsumed
        return false
      return true

    place:() ->
      this.placed = true
      this.currentAnim.alpha = 1

    getMineralsConsumed:()->
      this.mineralsConsumed

    getMineralsProduced:()->
      this.mineralsProduced

    getEnergyConsumed:()->
      this.energyConsumed

    getEnergyProduced:()->
      this.energyProduced

    getProductionProduced:()->
      this.productionProduced

    getProductionCost:()->
      this.productionCost

    getResearch:()->
      this.research
  )

  DomeGenerator = Placeable.extend(
    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    animSheet: new ig.AnimationSheet("media/dome_generator.png", 16, 16)

    energyConsumed: 100

    productionCost: 3000

    init:(x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim("idle", 0.05, [0,1,2,3,4,5,6,7])

    place:()->
      this.parent()
      generators = ig.game.getEntitiesByType(DomeGenerator)
      numGenerators = generators.length
      if ig.game.placeEntity in generators
        numGenerators -= 1

      if numGenerators >= 4
        ig.game.winning = true
        ig.game.winCondition = "generators"
  )

  QuantomOptoComptroller = Placeable.extend(
    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    animSheet: new ig.AnimationSheet("media/qo_comptroller.png", 16, 16)

    energyConsumed: 10

    productionCost: 1000

    init:(x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim("idle", 0.2, [0,1,2,3,])

    getEnergyProduced: () ->
      generators = generator for generator in ig.game.getEntitiesByType(Generator) when generator.placed
      energyProduced = 0
      energyProduced += 5 for generator in generators when generator.distanceTo(this) < 30
      return energyProduced
  )

  Supercollider = Placeable.extend(
    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    animSheet: new ig.AnimationSheet("media/supercollider.png", 16, 16)

    research: 20

    energyConsumed: 50

    productionCost: 2000

    init:(x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim("idle", 0.1, [0,0,0,0,0,0,0,0,0,1,2,3,4,5,6,7,8,9])

    getResearch:() ->
      researchCenters = center for center in ig.game.getEntitiesByType(ResearchCenter) when center.placed
      research = this.research
      research += 5 for center in researchCenters when center.distanceTo(this) < 30
      return energyProduced
  )

  ResearchCenter = Placeable.extend(
    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    animSheet: new ig.AnimationSheet("media/research_center.png", 16, 16)

    energyConsumed: 10

    research: 10

    productionCost: 100

    init:(x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim("idle", 0.1, [0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,4,4,3,2,1,0,0,0])
  )

  Borehole = Placeable.extend(
    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    animSheet: new ig.AnimationSheet("media/borehole.png", 16, 16)

    energyConsumed: 20

    productionCost: 200

    mineralsProduced: 20

    init:(x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim("idle", 0.2, [0,0,0,1,2,3,4,4,3,2,1,0,0,0])

    getMineralsProduced:()->
      mines = mine for mine in ig.game.getEntitiesByType(Mine) when mine.placed
      mineralsProduced = this.mineralsProduced
      mineralsProduced += 5 for mine in mines when mine.distanceTo(this) < 30
      return mineralsProduced
  )

  Generator = Placeable.extend(

    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    animSheet: new ig.AnimationSheet('media/generator.png', 16, 16)

    productionCost: 40
    energyProduced: 6

    init: (x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim('idle', 0.1, [0,1])
  )

  Mine = Placeable.extend(
    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    animSheet: new ig.AnimationSheet("media/mine.png", 16 ,16)

    energyConsumed: 2
    mineralsProduced: 3
    productionCost: 40

    init: (x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim('idle', 0.2, [0,1,2,3,4,4,4,4,4,4,4,3,2,1,0,0,0,0,0])
  )

  Factory = Placeable.extend(
    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    animSheet: new ig.AnimationSheet("media/factory.png", 16 ,16)

    energyConsumed: 6
    mineralsConsumed: 6
    productionProduced: 3
    productionCost: 100

    init: (x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim('idle', 0.4, [0,1])
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

    init: (x, y, buildingClass, enabled) ->
      tempInstance = new buildingClass(-100, -100, {})

      this.x = x
      this.y = y
      this.size = 16
      this.buildingClass = buildingClass
      this.image = tempInstance.animSheet.image
      this.enabled = if enabled? then enabled else true
      this.hovered = false
      this.queue = []

      tempInstance.kill()

    update: ()->
      if this.x < ig.input.mouse.x < this.x + this.size and this.y < ig.input.mouse.y < this.y + this.size and this.enabled
        this.hovered = true
        if ig.input.released("secondary_button")
          ig.game.buildQueue.add(this)
        if ig.input.released("primary_button") and this.queue.length > 0
          ig.game.updatePlaceEntity(this.queue[0], this)
      else
        this.hovered = false

    productionFinished: (entity) ->
      this.queue.push(entity)

    buildingPlaced: () ->
      this.queue.shift()
      if this.queue.length > 0
        ig.game.updatePlaceEntity(this.queue[0], this)
      else
        ig.game.updatePlaceEntity()

    draw: ()->
      if this.hovered
        this.buttonBack.drawTile(this.x, this.y, 1, this.size)
      else
        this.buttonBack.drawTile(this.x, this.y, 0, this.size)
      this.image.drawTile(this.x, this.y, 0, this.size)
      if not this.enabled
        this.buttonBack.drawTile(this.x, this.y, 1, this.size)

      ig.game.font.draw(this.queue.length.toString(), this.x, this.y-6)
  )

  BuildQueue = ig.Class.extend(

    queueBack: new ig.Image("media/queue_button.png")

    init: (x, y) ->
      this.x = x
      this.y = y
      this.tileSize = 16
      this.queue = []
      this.costCompleted = 0
      this.hover = null

    add: (buildButton) ->
      this.queue.push([buildButton, ig.game.spawnEntity(buildButton.buildingClass, -100,-100)])

    update:() ->
      this.hover = null
      if this.queue.length > 0
        this.costCompleted += ig.game.production / 60.0
        if this.costCompleted >= this.queue[0][1].getProductionCost()
          this.queue[0][0].productionFinished(this.queue[0][1])
          this.queue.shift()
          this.costCompleted = 0

        if this.x < ig.input.mouse.x < this.x + this.tileSize*this.queue.length
          if this.y < ig.input.mouse.y < this.y + this.tileSize
            this.hover = Math.floor((ig.input.mouse.x - this.x)/16)
            #this.hover = 1

      if this.hover? and (ig.input.released("primary_button") or ig.input.released("secondary_button"))
        this.queue[this.hover..this.hover] = []
        if this.hover == 0
            this.costCompleted = 0

    getScaledPercentDone:()->
      Math.max(
        Math.floor(this.costCompleted*16.0/this.queue[0][1].getProductionCost()),
        0.00001)

    drawQueueItem: (button, i) ->
      this.queueBack.drawTile(this.x + i*16, this.y, 0, this.tileSize)
      button.image.drawTile(this.x + i*16, this.y, 0, this.tileSize)
      if i == 0
        this.queueBack.draw(this.x, this.y-6,
          32, 0,
          this.getScaledPercentDone(), 6)

    draw: () ->
      this.drawQueueItem(queueItem[0], i) for queueItem, i in this.queue
      if this.hover?
        this.queueBack.drawTile(this.x + this.hover*16, this.y, 1, this.tileSize)
  )

  advRobotics =
    cost: 1000
    enabled: true
    researched: false
    name: "Advanced Robotics"
    desc: "Awesome robots work the mines more efficiently than humans!"
    bonuses: "Increases the efficiency of your mines."
    quote: "Beep. Whiirrrrrrrrr."

    onResearched: ()->
      extremeRobotics.enabled = true

  extremeRobotics =
    cost: 2000
    enabled: false
    researched: false
    name: "Extreme Environment Robotics"
    desc: "Remote control of robots under extreme conditions renders a whole new class
          of exploratory and geology problems solvable."
    bonus: "Further increases the efficiency of your mines. Enables construction of
           Asthenosphere Boreholes."
    quote: "Beep. <lava bubble>. Whirrr."

    onResearched: ()->
      ig.game.buildButtons[4].enabled = true

  highEnergyPhysics =
    cost: 1000
    enabled: true
    researched: false
    name: "High Energy Physics"
    desc: "Development of the tools and methods to handle high energy matter states gives
          you the tools for discovering what the universe is really made of."
    bonus: "Enables construction of Supercolliders."
    quote: "But, but, the chance of forming a black hole is like really really small!"

    onResearched: ()->
      ig.game.buildButtons[5].enabled = true
      quantumComputing.enabled = true

  quantumComputing =
    cost: 2000
    enabled: false
    researched: false
    name: "Quantum Computing"
    desc: "Understanding more of the subatomic particles of the universe, the first
          reliable quantum computers are built and go into service."
    bonus: "Enables construction of Quantum-Optical Comptrollers."
    quote: "Wednesday, we'll calculate all the digits of Pi; Thursday, we should work on
           that overdue 30-billion-node neural net, and Friday, what the hell, let's
           simulate the universe."

    onResearched:()->
      ig.game.buildButtons[6].enabled = true
      unifiedTheory.enabled = true

  theoryOfEverything =
    cost: 3000
    enabled: false
    researched: false
    name: "Theory of Everything"
    desc: "Using data from High Energy Physics and analysis tools from Quantum Computing,
          the first truly universal theory of physics is discovered."
    bonus: "Enables construction of Dome Generators."
    quote: "It makes so much sense! Igor, why didn't we think of this before?!"

    onResearched:() ->
      ig.game.buildButtons[7].enabled = true
      secretsOfTheUniverse.enabled = true

  secretsOfTheUniverse =
    cost: 5000
    enabled: false
    researched: false
    name: "Secrets of the Universe"
    desc: "???"
    bonus: "???"
    quote: "And there they were, the mortals, always rushing to the end of their hurried
           lives. I saw everything, and it was sad and beautiful."

    onResearched:() ->
      ig.game.winning = true
      ig.game.winCondition = "secrets"

  MyGame = ig.Game.extend(

    # Load a font
    font: new ig.Font( 'media/04b03.font.png' )

    # HUD graphics
    leftPanelBg: new ig.Image("media/left_panel.png")
    lowerPanelBg: new ig.Image("media/lower_panel.png")
    pauseBlackout: new ig.Image("media/pause_blackout.png")

    init: () ->
      # Initialize your game here; bind keys etc.
      ig.input.bind(ig.KEY.MOUSE1, 'primary_button')
      ig.input.bind(ig.KEY.MOUSE2, 'secondary_button')
      ig.input.bind(ig.KEY.SPACE, "pause")

      this.paused = false

      this.spawnEntity(BackGround, 0, 0)
      this.updatePlaceEntity(null)

      this.buildButtons = [
        new BuildingButton(61, 224, Mine)
        new BuildingButton(77, 224, Generator)
        new BuildingButton(93, 224, Factory)
        new BuildingButton(113, 224, ResearchCenter)
        new BuildingButton(129, 224, Borehole, false)
        new BuildingButton(145, 224, Supercollider, false)
        new BuildingButton(161, 224, QuantomOptoComptroller, false)
        new BuildingButton(177, 224, DomeGenerator, false)
      ]

      this.alerts = [{text:"Here's a sample alert!", time:120}]
      this.priorityAlert = null

      this.buildButtons[0].productionFinished(ig.game.spawnEntity(Mine, -100, -100))
      this.buildButtons[0].productionFinished(ig.game.spawnEntity(Mine, -100, -100))
      this.buildButtons[1].productionFinished(ig.game.spawnEntity(Generator, -100, -100))
      this.buildButtons[1].productionFinished(ig.game.spawnEntity(Generator, -100, -100))
      this.buildButtons[2].productionFinished(ig.game.spawnEntity(Factory, -100, -100))

      this.buildQueue = new BuildQueue(200, 224)

      this.updateEconomyState()

      this.researchGoal = {name:""}

    updatePlaceEntity: (placeEntity, buttonToUpdate) ->
      this.buttonToUpdate = buttonToUpdate
      if this.placeEntity?
        if not this.placeEntity.placed
          this.placeEntity.pos.x = -300
      this.placeEntity = placeEntity
      if placeEntity? and placeEntity.currentAnim?
        this.placeEntity.currentAnim.alpha = 0.5

    updateEconomyState:()->
      this.energyProduced = 0
      this.energyConsumed = 0
      this.mineralsProduced = 0
      this.mineralsConsumed = 0
      this.production = 0
      this.research = 0

      placedEntities = (entity for entity in this.entities when entity.placed)

      this.energyProduced += entity.getEnergyProduced() for entity in placedEntities
      this.energyConsumed += entity.getEnergyConsumed() for entity in placedEntities
      this.mineralsProduced += entity.getMineralsProduced() for entity in placedEntities
      this.mineralsConsumed += entity.getMineralsConsumed() for entity in placedEntities
      this.production += entity.getProductionProduced() for entity in placedEntities
      this.research += entity.getResearch() for entity in placedEntities

    update: () ->
      if not this.paused
        this.updateEconomyState()

        # Update all entities and backgroundMaps
        this.parent();

        button.update() for button in this.buildButtons

        this.buildQueue.update()

        placeX = Math.floor(ig.input.mouse.x/16)*16
        placeY = Math.floor(ig.input.mouse.y/16)*16

        # Add your own, additional update code here
        if ig.input.released("primary_button") and this.legalPlacement(placeX, placeY)
            if this.placeEntity? and this.placeEntity.canPlace()
              this.placeEntity.place()
              if this.buttonToUpdate?
                this.buttonToUpdate.buildingPlaced()
        else if this.placeEntity
          this.placeEntity.pos.x = placeX
          this.placeEntity.pos.y = placeY

        if this.alerts.length > 0
          this.alerts[0].time -= 1
          if this.alerts[0].time <= 0
            this.alerts.shift()

      if ig.input.released("pause")
        this.paused = not this.paused

    legalPlacement: (x, y)->
      if x < 64
        return y < 176
      else
        return y < 192

    draw: () ->
      # Draw all entities and backgroundMaps
      this.parent();

      # Add your own drawing code here
      # have to draw the UI here

      #alert pane
      this.lowerPanelBg.draw(-32, 193)
      if this.alerts.length > 0
        this.font.draw(this.alerts[0].text, 61, 195)

      # research info pane
      this.lowerPanelBg.draw(-16, 201)
      this.font.draw(sprintf("Research: %+.0d", this.research), 61, 203)
      this.font.draw("Goal: #{this.researchGoal.name}", 140, 203)

      #building pane
      this.lowerPanelBg.draw(0, 209)

      this.font.draw("Build:", 61, 212)
      button.draw() for button in this.buildButtons

      this.font.draw("Queue:", 200, 212)
      this.buildQueue.draw()

      #production pane
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

      if this.paused
        this.pauseBlackout.draw(0,0)
  )

  # Start the Game with 60fps, a resolution of 320x240, scaled
  # up by a factor of 2
  ig.main( '#canvas', MyGame, 60, 320, 240, 2 )
)