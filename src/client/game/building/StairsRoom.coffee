Room = require './Room'
Stairs = require './objects/Stairs'

class SafeRoom extends Room
  constructor: ({up, right, down, left, objectClickHandler}) ->
    super({up, right, down, left, objectClickHandler})
    Object.assign @description,
      header: 'Stairs Room'
      text: 'Here you can enter the next Floor of the current building'
    @isStairs = true

  addObjects: (objectClickHandler) ->
    @objects.push new Stairs @, objectClickHandler

module.exports = SafeRoom
