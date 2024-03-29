// Generated by CoffeeScript 1.3.3
(function() {

  ig.module("game.windmaster.entities.factory").requires('impact.game', 'impact.animation', 'game.windmaster.entities.placeable').defines(function() {
    return window.Factory = Placeable.extend({
      size: {
        x: 16,
        y: 16
      },
      collides: ig.Entity.COLLIDES.PASSIVE,
      animSheet: new ig.AnimationSheet("media/windmaster/factory.png", 16, 16),
      name: "Factory",
      energyConsumed: 6,
      mineralsConsumed: 6,
      productionProduced: 3,
      productionCost: 100,
      init: function(x, y, settings) {
        this.parent(x, y, settings);
        return this.addAnim('idle', 0.4, [0, 1]);
      }
    });
  });

}).call(this);
