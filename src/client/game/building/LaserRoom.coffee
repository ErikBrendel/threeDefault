Room = require './Room'
Laser = require './objects/Laser'

class LaserRoom extends Room
  constructor: ({up, right, down, left, type, objectClickHandler}) ->
    super({up, right, down, left, type, objectClickHandler})
    @description = 'Laser Room'

  addObjects: (objectClickHandler) ->
    @objects.push new Laser @, objectClickHandler


module.exports = LaserRoom
