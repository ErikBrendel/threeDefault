# every geometry inside a room is a RoomObject

loadHoverEffect = require '../../actor/HoverEffect'

class RoomObject
  constructor: (@type, @room, clickHandler) ->
    @visible = false
    @mesh = AssetCache.getModel "objects/#{@type}"
    @mesh.userData.clickHandler = => clickHandler @
    loadHoverEffect @mesh, @isVisible
    @room.add @mesh

  isVisible: =>
    @visible

  onInteract: (person) ->

  onEnter: (person, oldRoom) ->
    @visible = true if person.type == 'player'

  onLeave: (person, newRoom) ->
    @visible = false if person.type == 'player'



module.exports = RoomObject
