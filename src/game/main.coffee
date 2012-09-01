ig.module(
  'game.main'
)
.requires(
  'impact.game'
  #'impact.font'
)
.defines(() ->

  EntityGenerator = ig.Entity.extend(

    size: {x:16, y:16}

    collides: ig.Entity.COLLIDES.PASSIVE

    animSheet: new ig.AnimationSheet('media/generator.png', 16, 16)

    init: (x, y, settings) ->
      this.parent(x, y, settings)
      this.addAnim('idle', 0.1, [0,1])
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
      ig.input.bind(ig.KEY.MOUSE1, 'place_generator')
      this.spawnEntity(BackGround, 0, 0)

    update: () ->
      # Update all entities and backgroundMaps
      this.parent();

      # Add your own, additional update code here
      if ig.input.state("place_generator")
        this.spawnEntity(EntityGenerator, ig.input.mouse.x, ig.input.mouse.y)

    draw: () ->
      this.bg.draw(0,0)

      # Draw all entities and backgroundMaps
      this.parent();

      # Add your own drawing code here
  )

  # Start the Game with 60fps, a resolution of 320x240, scaled
  # up by a factor of 2
  ig.main( '#canvas', MyGame, 60, 320, 240, 2 )
)