# every geometry inside a room is a RoomObject

class RoomObject
  constructor: (@type, @room, clickHandler) ->
    @mesh = AssetCache.getModel "objects/#{@type}"
    @mesh.userData.clickHandler = => clickHandler @
    @room.add @mesh


  onInteract: (person) ->
  onEnter: (person, oldRoom) ->
  onLeave: (person, newRoom) ->


module.exports = RoomObject
