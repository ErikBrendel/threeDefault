AlarmRoom = require './AlarmRoom'
Laser = require './objects/Laser'

class LaserRoom extends AlarmRoom
  constructor: ({up, right, down, left, type, objectClickHandler}) ->
    super({up, right, down, left, type, objectClickHandler})
    @enteredSilently = false
    @description =
      header: 'Laser Room'
      text: 'You have to walk in carefully to not trigger the alarm. If you just run in, the guards will come for you.'

  addObjects: (objectClickHandler) ->
    super(objectClickHandler)
    @objects.push new Laser @, objectClickHandler

  onEnter: (person, oldRoom) ->
    super(person, oldRoom)
    @triggerAlarm() unless @enteredSilently or person.type isnt 'player'
    @enteredSilently = false

module.exports = LaserRoom
