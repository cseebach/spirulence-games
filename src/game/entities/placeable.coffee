ig.module(
  "game.entities.placeable"
).requires(
  "impact.entity"
  "impact.game"
).defines ->
  window.Placeable = ig.Entity.extend(
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