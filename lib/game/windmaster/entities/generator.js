// Generated by CoffeeScript 1.3.3
(function() {

  ig.module("game.windmaster.entities.generator").requires('impact.game', 'impact.animation', 'game.windmaster.entities.placeable').defines(function() {
    return window.Generator = Placeable.extend({
      size: {
        x: 16,
        y: 16
      },
      collides: ig.Entity.COLLIDES.PASSIVE,
      name: "Wind Generator",
      animSheet: new ig.AnimationSheet('media/windmaster/generator.png', 16, 16),
      productionCost: 40,
      energyProduced: 6,
      init: function(x, y, settings) {
        this.parent(x, y, settings);
        return this.addAnim('idle', 0.1, [0, 1]);
      }
    });
  });

}).call(this);
