Room = require './Room'
Alarm = require './objects/Alarm'

class AlarmRoom extends Room
  constructor: ({up, right, down, left, type, objectClickHandler}) ->
    super({up, right, down, left, type, objectClickHandler})

  addObjects: (objectClickHandler) ->
    @objects.push new Alarm @, objectClickHandler


  triggerAlarm: ->
    console.log 'Alarm! Alarm! Alarm!'
    gs.guard.targetRoom = @

module.exports = AlarmRoom
