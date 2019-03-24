Room = require './Room'
Safe = require './objects/Safe'
SafeLock = require './objects/SafeLock'

class SafeRoom extends Room
  constructor: ({up, right, down, left, objectClickHandler}) ->
    super({up, right, down, left, objectClickHandler})
    Object.assign @description,
      header: 'Safe Room'
      text: 'There is a safe in this room! Crack it to receive the treasures inside!'

  addObjects: (objectClickHandler) ->
    safe = new Safe @, objectClickHandler
    @objects.push safe
    @objects.push new SafeLock @, objectClickHandler, safe

  onEnter: (person, oldRoom) =>
    super(person, oldRoom)
    return unless @objects[0]?
    if person.type is 'guard' and @objects[0].doorOpened
      person.setAlerted()
      @objects[0].onInteract person


module.exports = SafeRoom
