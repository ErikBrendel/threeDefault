Wall = require './Wall'
Ground = require './Ground'

{ Group } = THREE

class Room extends Group
  constructor: ({up, right, down, left}) ->
    super()
    @wallUp = new Wall Math.PI * 0.5, up
    @wallLeft = new Wall Math.PI, left
    @wallDown = new Wall Math.PI * 1.5, down
    @wallRight = new Wall 0, right
    @add wall for wall in [@wallUp, @wallRight, @wallDown, @wallLeft]
    @ground = new Ground
    @add @ground

module.exports = Room
