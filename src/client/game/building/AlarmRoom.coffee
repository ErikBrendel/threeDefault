Room = require './Room'
Alarm = require './objects/Alarm'
AlarmLight = require './../actor/AlarmLight'

class AlarmRoom extends Room

  constructor: ({up, right, down, left, type, objectClickHandler}) ->
    super({up, right, down, left, type, objectClickHandler})

  addObjects: (objectClickHandler) ->
    @alarm = new Alarm @, objectClickHandler
    @objects.push @alarm

  onEnter: (person, oldRoom) =>
    super(person, oldRoom)
    @deactivateAlarm() if person.type isnt 'player'

  triggerAlarm: ->
    console.log 'Alarm! Alarm! Alarm!'
    AlarmLight.instance().setRoom @
    gs.guard.targetRoom = @
    gs.guard.setAlerted()

  deactivateAlarm: ->
    AlarmLight.instance().deactivate() if AlarmLight.instance().room is @


module.exports = AlarmRoom
