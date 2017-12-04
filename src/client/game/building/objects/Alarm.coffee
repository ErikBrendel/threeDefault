# the (un)penetrable vault that stores all kinds of treasures

RoomObject = require './RoomObject'
loadHoverEffect = require '../../actor/HoverEffect'
Constants = require '../../../config/Constants'

class Alarm extends RoomObject
  constructor: (room, clickHandler) ->
    super 'alarm', room, clickHandler
    @hasFocus = true

  onInteract: (person) ->

  isVisible: ->
    false

module.exports = Alarm
