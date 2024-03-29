// Generated by CoffeeScript 1.3.3
(function() {
  var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  ig.module('game.windmaster.entities.domegen').requires('impact.game', 'game.windmaster.entities.placeable').defines(function() {
    return window.DomeGenerator = Placeable.extend({
      size: {
        x: 16,
        y: 16
      },
      collides: ig.Entity.COLLIDES.PASSIVE,
      animSheet: new ig.AnimationSheet("media/windmaster/dome_generator.png", 16, 16),
      energyConsumed: 100,
      productionCost: 3000,
      name: "Dome Generator",
      init: function(x, y, settings) {
        this.parent(x, y, settings);
        return this.addAnim("idle", 0.05, [0, 1, 2, 3, 4, 5, 6, 7]);
      },
      place: function() {
        var generators, numGenerators, _ref;
        this.parent();
        generators = ig.game.getEntitiesByType(DomeGenerator);
        numGenerators = generators.length;
        if (_ref = ig.game.placeEntity, __indexOf.call(generators, _ref) >= 0) {
          numGenerators -= 1;
        }
        if (numGenerators >= 4) {
          ig.game.winning = true;
          return ig.game.winCondition = "generators";
        }
      }
    });
  });

}).call(this);
