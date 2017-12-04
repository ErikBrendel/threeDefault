# every geometry inside a room is a RoomObject

loadHoverEffect = require '../../actor/HoverEffect'

class RoomObject
  constructor: (@type, @room, @clickHandler, @focusData, hoverOptions) ->
    @visible = false
    @mesh = AssetCache.getModel "objects/#{@type}",
      copyMaterials: true
    loadHoverEffect @mesh, @isVisible, (=> @clickHandler @), hoverOptions
    @room.add @mesh
    @hasFocus = false

  getFocusData: ->
    @focusData.offset = @room.position
    return @focusData

  isVisible: => @visible

  onInteract: (person) ->

  onEnter: (person, oldRoom) ->
    @visible = true if person.type == 'player'

  onLeave: (person, newRoom) ->
    @visible = false if person.type == 'player'



module.exports = RoomObject
