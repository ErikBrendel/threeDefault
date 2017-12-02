Wall = require './Wall'

{ Group } = THREE

class Room extends Group
  constructor: ({up, right, down, left}) ->
    super()
    @addWalls up, right, down, left
    @addGround()

  addWalls: (up, right, down, left) ->
    @wallUp = new Wall Math.PI * 0.5, up
    @wallLeft = new Wall Math.PI, left
    @wallDown = new Wall Math.PI * 1.5, down
    @wallRight = new Wall 0, right
    @add wall for wall in [@wallUp, @wallRight, @wallDown, @wallLeft]

  addGround: ->
    @ground = AssetCache.getModel 'ground'
    @ground.userData.clickHandler = =>
      console.log('you clicked the ground')
      @onGroundClick? @
    @add @ground

module.exports = Room
