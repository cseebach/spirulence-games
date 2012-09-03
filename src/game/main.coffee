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
        ig.game.alerts.push({time:120, text:"Can't place building: not enough minerals."})
        return false
      if this.getEnergyConsumed() >  ig.game.energyProduced - ig.game.energyConsumed
        ig.game.alerts.push({time:120, text:"Can't place building: not enough energy."})
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

    name: "Dome Generator"

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

    name: "Quantum-Optical Comptroller"

    init:(x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim("idle", 0.2, [0,1,2,3,])

    getEnergyProduced: () ->
      generators = (generator for generator in ig.game.getEntitiesByType(Generator) when generator.placed)
      energyProduced = 0
      energyProduced += 5 for generator in generators when generator.distanceTo(this) < 30
      return energyProduced
  )

  Supercollider = Placeable.extend(
    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    animSheet: new ig.AnimationSheet("media/supercollider.png", 16, 16)

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

  ResearchCenter = Placeable.extend(
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

  Borehole = Placeable.extend(
    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    animSheet: new ig.AnimationSheet("media/borehole.png", 16, 16)

    energyConsumed: 20

    productionCost: 200

    mineralsProduced: 20

    name: "Asthenosphere Borehole"

    init:(x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim("idle", 0.2, [0,0,0,1,2,3,4,4,3,2,1,0,0,0])

    getMineralsProduced:()->
      mines = (mine for mine in ig.game.getEntitiesByType(Mine) when mine.placed)
      mineralsProduced = this.mineralsProduced
      mineralsProduced += 5 for mine in mines when mine.distanceTo(this) < 30
      return mineralsProduced
  )

  Generator = Placeable.extend(

    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    name: "Wind Generator"

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

    name: "Mine"

    energyConsumed: 2
    mineralsProduced: 3
    productionCost: 40

    init: (x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim('idle', 0.2, [0,1,2,3,4,4,4,4,4,4,4,3,2,1,0,0,0,0,0])

    getMineralsProduced:()->
      mineralsProduced = this.mineralsProduced
      if advRobotics.researched
        mineralsProduced += 1
      if extremeRobotics.researched
        mineralsProduced += 1
      return mineralsProduced
  )

  Factory = Placeable.extend(
    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    animSheet: new ig.AnimationSheet("media/factory.png", 16 ,16)

    name: "Factory"

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
      this.instance = new buildingClass()

      this.x = x
      this.y = y
      this.size = 16
      this.buildingClass = buildingClass
      this.enabled = if enabled? then enabled else true
      this.hovered = false
      this.queue = []

    update: ()->
      if this.x < ig.input.mouse.x < this.x + this.size and this.y < ig.input.mouse.y < this.y + this.size and this.enabled
        this.hovered = true

        ig.game.hoverInfo = this.instance.name
        buildMessage = []
        if this.instance.getMineralsConsumed() > 0
          buildMessage.push(sprintf("M-%.0d", this.instance.getMineralsConsumed()))
        if this.instance.getMineralsProduced() > 0
          buildMessage.push(sprintf("M+%.0d", this.instance.getMineralsProduced()))
        if this.instance.getEnergyConsumed() > 0
          buildMessage.push(sprintf("E-%.0d", this.instance.getEnergyConsumed()))
        if this.instance.getEnergyProduced() > 0
          buildMessage.push(sprintf("E+%.0d", this.instance.getEnergyProduced()))
        if this.instance.getProductionCost() > 0
          buildMessage.push(sprintf("P%.0d", this.instance.getProductionCost()))
        if this.instance.getProductionProduced() > 0
          buildMessage.push(sprintf("P+%.0d", this.instance.getProductionProduced()))
        if this.instance.getResearch() > 0
          buildMessage.push(sprintf("R+%.0d", this.instance.getResearch()))

        ig.game.buildMessage = buildMessage.join(" ")

        if ig.input.released("secondary_button")
          if ig.game.buildQueue.isFull()
            ig.game.alerts.push({text:"Can't add to queue: queue is full.", time:80})
          else
            ig.game.buildQueue.add(this)
        if ig.input.released("primary_button") and this.queue.length > 0
          ig.game.updatePlaceEntity(this.queue[0], this)
      else
        this.hovered = false

    productionFinished: (entity) ->
      this.queue.push(entity)

    getBuildingImage:()->
      this.instance.animSheet.image

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
      this.instance.animSheet.image.drawTile(this.x, this.y, 0, this.size)
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

    isFull:() ->
      return this.queue.length >= 7

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
      button.getBuildingImage().drawTile(this.x + i*16, this.y, 0, this.tileSize)
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
    bonus: "Increases the efficiency of your mines."
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
    bonus: "Further increases the efficiency of your mines. Enables construction of\nAsthenosphere Boreholes."
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

  techs = [
    advRobotics, extremeRobotics, highEnergyPhysics, quantumComputing,
    theoryOfEverything, secretsOfTheUniverse
  ]

  MyGame = ig.Game.extend(

    # Load a font
    font: new ig.Font( 'media/04b03.font.png' )

    # HUD graphics
    panelBg: new ig.Image("media/blue_bg.png")
    smallTextBg: new ig.Image("media/small_text_button_bg.png")
    caretBg: new ig.Image("media/caret_button_bg.png")

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

      this.alerts = [{text:"Welcome to Windmaster.", time:120}]
      this.hoverInfo = null

      this.showingResearchPane = false
      this.currentDisplayedTech = null
      this.availableTechs = null

      this.buildButtons[0].productionFinished(ig.game.spawnEntity(Mine, -100, -100))
      this.buildButtons[0].productionFinished(ig.game.spawnEntity(Mine, -100, -100))
      this.buildButtons[1].productionFinished(ig.game.spawnEntity(Generator, -100, -100))
      this.buildButtons[1].productionFinished(ig.game.spawnEntity(Generator, -100, -100))
      this.buildButtons[2].productionFinished(ig.game.spawnEntity(Factory, -100, -100))

      this.buildQueue = new BuildQueue(200, 224)

      this.updateEconomyState()

      this.researchGoal = {name:""}
      this.buildMessage = ""

      this.researchPaneButtonHovered = null

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

        this.hoverInfo = null
        this.buildMessage = ""

        # Update all entities and backgroundMaps
        this.parent();

        button.update() for button in this.buildButtons

        this.buildQueue.update()

        if this.researchGoal.cost?
          this.researchCompleted += this.research/60.0
          if this.researchCompleted > this.researchGoal.cost
            this.researchGoal.onResearched()
            this.researchGoal.researched = true
            this.researchCompleted = 0
            this.researchGoal = {name:""}

        placeX = Math.floor(ig.input.mouse.x/16)*16
        placeY = Math.floor(ig.input.mouse.y/16)*16

        # Add your own, additional update code here
        if ig.input.released("primary_button") and not this.inGUI(placeX, placeY) and this.placeEntity? and this.placeEntity.canPlace() and this.legalPlacement(placeX, placeY)
          this.placeEntity.place()
          this.buttonToUpdate.buildingPlaced()
        else if this.placeEntity
          this.placeEntity.pos.x = placeX
          this.placeEntity.pos.y = placeY

        if this.alerts.length > 0
          this.alerts[0].time -= 1
          if this.alerts[0].time <= 0
            this.alerts.shift()

        if ig.input.released("primary_button") and  304 > ig.input.mouse.x > 58 and 212 > ig.input.mouse.y > 203
          this.showingResearchPane = true
          this.availableTechs = (tech for tech in techs when tech.enabled and not tech.researched)
          this.currentlyDisplayedTech = 0
          if this.availableTechs.length == 0
            this.currentDisplayedTech = -1

        if this.showingResearchPane
          this.researchPaneButtonHovered = null
          if 316 > ig.input.mouse.x >= 280
            if 10 > ig.input.mouse.y >= 2
              this.researchPaneButtonHovered = "choose"
            else if 18 > ig.input.mouse.y >= 10
              this.researchPaneButtonHovered = "close"

          if this.researchPaneButtonHovered == "choose" and ig.input.released("primary_button")
            this.researchGoal = this.availableTechs[this.currentlyDisplayedTech]
            this.showingResearchPane = false
            this.researchCompleted = 0
          else if this.researchPaneButtonHovered == "close" and ig.input.released("primary_button")
            this.showingResearchPane = false

          this.availableResearchSwitchButtonHovered = null
          if 8 >= ig.input.mouse.y >= 1
            if 140 > ig.input.mouse.x >= 132
              this.availableResearchSwitchButtonHovered = ">"
            else if 132 > ig.input.mouse.x >= 124
              this.availableResearchSwitchButtonHovered = "<"

          if this.availableResearchSwitchButtonHovered == "<" and ig.input.released("primary_button")
            this.currentlyDisplayedTech -= 1
            if this.currentlyDisplayedTech == -1
              this.currentlyDisplayedTech = this.availableTechs.length - 1
          else if this.availableResearchSwitchButtonHovered == ">" and ig.input.released("primary_button")
            this.currentlyDisplayedTech += 1
            if this.currentlyDisplayedTech >= this.availableTechs.length
              this.currentlyDisplayedTech = 0


      if ig.input.released("pause")
        this.paused = not this.paused

    inGUI:(x, y) -> (x < 64 and y > 176) or y > 192

    legalPlacement: (x, y)->
      sameSpot = (true for entity in this.entities when entity.pos.x == x and entity.pos.y == y)
      if sameSpot.length > 1
        this.alerts.push({time:120, text:"Can't place building there: space occupied."})
        return false
      return true

    draw: () ->
      # Draw all entities and backgroundMaps
      this.parent();

      #alert pane
      this.panelBg.draw(-32, 193)
      if this.hoverInfo?
        this.font.draw(this.hoverInfo, 61, 195)
      else if this.alerts.length > 0
        this.font.draw(this.alerts[0].text, 61, 195)

      # research info pane
      this.panelBg.draw(-16, 201)
      this.font.draw(sprintf("Research: %+.0d", this.research), 61, 203)
      this.font.draw("Goal: #{this.researchGoal.name}", 140, 203)

      #building pane
      this.panelBg.draw(0, 209)
      this.font.draw("Build: #{this.buildMessage}", 61, 212)
      button.draw() for button in this.buildButtons

      this.font.draw("Queue:", 200, 212)
      this.buildQueue.draw()

      #production pane
      this.panelBg.draw(-262, 181)

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

      if this.showingResearchPane
        this.panelBg.draw(0, -190)

        if this.availableResearchSwitchButtonHovered == "<"
          this.caretBg.drawTile(124, 0, 1, 8)
        else
          this.caretBg.drawTile(124, 0, 0, 8)

        if this.availableResearchSwitchButtonHovered == ">"
          this.caretBg.drawTile(132, 0, 1, 8)
        else
          this.caretBg.drawTile(132, 0, 0, 8)

        this.font.draw("Available Research Goals:   < >", 3, 1)
        tech = this.availableTechs[this.currentlyDisplayedTech]
        this.font.draw(tech.name, 3, 15)
        this.font.draw(tech.bonus, 3, 25)

        if this.researchPaneButtonHovered == "choose"
          this.smallTextBg.drawTile(280, 2, 1, 36, 8)
        else
          this.smallTextBg.drawTile(280, 2, 0, 36, 8)
        this.font.draw("CHOOSE", 298, 3, ig.Font.ALIGN.CENTER)

        if this.researchPaneButtonHovered == "close"
          this.smallTextBg.drawTile(280, 10, 1, 36, 8)
        else
          this.smallTextBg.drawTile(280, 10, 0, 36, 8)
        this.font.draw("CLOSE", 298, 11, ig.Font.ALIGN.CENTER)

      if this.paused
        this.pauseBlackout.draw(0,0)
  )

  # Start the Game with 60fps, a resolution of 320x240, scaled
  # up by a factor of 2
  ig.main( '#canvas', MyGame, 60, 320, 240, 2 )
)