Room = require './AlarmRoom'
Laser = require './objects/Laser'

class LaserRoom extends AlarmRoom
  constructor: ({up, right, down, left, type, objectClickHandler}) ->
    super({up, right, down, left, type, objectClickHandler})
    @description = 'Laser Room'
    @enteredSilently = false

  addObjects: (objectClickHandler) ->
    super(objectClickHandler)
    @objects.push new Laser @, objectClickHandler

  onEnter: (person, oldRoom) ->
    super(person, oldRoom)
    @triggerAlarm() unless @enteredSilently or person.type isnt 'player'
    @enteredSilently = false

module.exports = LaserRoom
