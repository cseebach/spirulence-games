// Generated by CoffeeScript 1.3.3
(function() {

  ig.module("game.windmaster.entities.borehole").requires('impact.game', 'impact.animation', 'game.windmaster.entities.placeable').defines(function() {
    return window.Borehole = Placeable.extend({
      size: {
        x: 16,
        y: 16
      },
      collides: ig.Entity.COLLIDES.PASSIVE,
      animSheet: new ig.AnimationSheet("media/windmaster/borehole.png", 16, 16),
      energyConsumed: 20,
      productionCost: 200,
      mineralsProduced: 20,
      name: "Asthenosphere Borehole",
      init: function(x, y, settings) {
        this.parent(x, y, settings);
        return this.addAnim("idle", 0.2, [0, 0, 0, 1, 2, 3, 4, 4, 3, 2, 1, 0, 0, 0]);
      },
      getMineralsProduced: function() {
        var mine, mineralsProduced, mines, _i, _len;
        mines = (function() {
          var _i, _len, _ref, _results;
          _ref = ig.game.getEntitiesByType(Mine);
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            mine = _ref[_i];
            if (mine.placed) {
              _results.push(mine);
            }
          }
          return _results;
        })();
        mineralsProduced = this.mineralsProduced;
        for (_i = 0, _len = mines.length; _i < _len; _i++) {
          mine = mines[_i];
          if (mine.distanceTo(this) < 30) {
            mineralsProduced += 5;
          }
        }
        return mineralsProduced;
      }
    });
  });

}).call(this);
