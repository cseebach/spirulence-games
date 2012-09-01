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
  )

  Mine = ig.Entity.extend(
    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    animSheet: new ig.AnimationSheet("media/mine.png", 16 ,16)

    init: (x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim('idle', 0.2, [0,1,2,3,4,4,4,4,4,4,4,3,2,1,0,0,0,0,0])
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
    #font: new ig.Font( 'media/04b03.font.png' )

    bg: new ig.Image('media/background.png')

    init: () ->
      # Initialize your game here; bind keys etc.
      ig.input.bind(ig.KEY.MOUSE1, 'place_building')
      this.spawnEntity(BackGround, 0, 0)
      this.placeClass = Mine
      this.placeEntity = this.spawnEntity(this.placeClass, -100, -100)
      this.placeEntity.currentAnim.alpha = 0.5

    update: () ->
      # Update all entities and backgroundMaps
      this.parent();

      placeX = Math.floor(ig.input.mouse.x/16)*16
      placeY = Math.floor(ig.input.mouse.y/16)*16

      # Add your own, additional update code here
      if ig.input.released("place_building")
        this.spawnEntity(this.placeClass, placeX, placeY)
      else
        this.placeEntity.pos.x = placeX
        this.placeEntity.pos.y = placeY

    draw: () ->
      # Draw all entities and backgroundMaps
      this.parent();

      # Add your own drawing code here
      # have to draw the UI here
  )

  # Start the Game with 60fps, a resolution of 320x240, scaled
  # up by a factor of 2
  ig.main( '#canvas', MyGame, 60, 320, 240, 2 )
)