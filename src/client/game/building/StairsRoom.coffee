Room = require './Room'
Stairs = require './objects/Stairs'

class SafeRoom extends Room
  constructor: ({up, right, down, left, type, objectClickHandler}) ->
    super({up, right, down, left, type, objectClickHandler})
    @description = 'Stairs Room'

  addObjects: (objectClickHandler) ->
    @objects.push new Stairs @, objectClickHandler


module.exports = SafeRoom
