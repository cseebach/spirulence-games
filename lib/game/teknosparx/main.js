// Generated by CoffeeScript 1.3.3
(function() {

  ig.module("game.teknosparx.main").requires("impact.game", "game.teknosparx.levels.world").defines(function() {
    var Teknosparx;
    Teknosparx = ig.Game.extend({
      init: function() {
        return ig.game.loadLevel(LevelWorld);
      },
      update: function() {
        return this.parent();
      },
      draw: function() {
        return this.parent();
      }
    });
    return ig.main('#canvas', Teknosparx, 60, 320, 240, 2);
  });

}).call(this);