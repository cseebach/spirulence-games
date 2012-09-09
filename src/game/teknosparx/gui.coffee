ig.module(
  "game.teknosparx.gui"
).requires(
  "impact.impact"
).defines () ->

  window.MouseArea = ig.Class.extend(

    init:(x,y, width, height) ->
      this.x = x
      this.y = y
      this.width = width
      this.height = height

    onClicked:()->

    update:()->
      this.hovered = false
      mouseX = ig.input.mouse.x
      mouseY = ig.input.mouse.y
      if mouseX > this.x and mouseY > this.y
        if mouseX < this.x + this.width and mouseY < this.y + this.height
          this.hovered = true
          if ig.input.released("primary_button") or ig.input.pressed("primary_button")
            if not ig.game._mouseIntercepted
              ig.game.mouseIntercepted()
              this.onClicked()

    draw:()->

  )

  window.Panel = window.MouseArea.extend(

    init:(x, y, image) ->
      this.image = image
      this.parent(x, y, image.width, image.height)

    draw:()->
      this.image.draw(this.x, this.y)
  )

  window.Button = window.MouseArea.extend(

    init: (x, y, image, text, font) ->
      this.imageTileWidth = image.width/2.0
      this.image = image
      this._text = text
      this.font = font

      this.parent(x, y, this.imageTileWidth, image.height)

    draw:() ->
      this.parent()

      if this.hovered
        this.image.drawTile(this.x, this.y, 1, this.imageTileWidth, this.image.height)
      else
        this.image.drawTile(this.x, this.y, 0, this.imageTileWidth, this.image.height)

      textWidth = this.font.widthForString(this._text)
      xOffset = (this.imageTileWidth - textWidth)/2.0
      this.font.draw(this._text, this.x + xOffset, this.y+2)

  )