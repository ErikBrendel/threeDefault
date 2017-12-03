# The connection between two rooms,
# including mesh, type and logic

SmoothValue = require '../../util/SmoothValue'
loadHoverEffect = require '../actor/HoverEffect'

vec3 = (x, y, z) -> new THREE.Vector3 x, y, z

Player_Dist = 0.5
PlayerPosition = [
  [vec3(-Player_Dist, 0, 0), vec3(Player_Dist, 0, 0)],
  [vec3(0, 0, -Player_Dist), vec3(0, 0, Player_Dist)]
]

Camera_Dist = 1.5
Camera_Height = 3
Camera_Offset = 1
CameraPosition = [
  [vec3(-Camera_Dist, Camera_Height, Camera_Offset), vec3(Camera_Dist, Camera_Height, Camera_Offset)],
  [vec3(0, Camera_Height, Camera_Dist / 2), vec3(0, Camera_Height, Camera_Dist)]
]

FocusPosition = [
  [vec3(0, 1, 0), vec3(0, 1, 0)],
  [vec3(0, 1, 0), vec3(0, 1, 0)]
]

CenterOffset = [
  vec3(0, 0, 0.5),
  vec3(0.5, 0, 0)
]


class Door
  # rotated=false === RL-DOOR
  constructor: (@rotated, clickHandler, @firstRoom, @secondRoom) ->
    @allowRoomMovement = true
    @hasFocus = false
    #TODO focus animation here maybe
    @visible = false
    @mesh = AssetCache.getModel 'door',
      copyMaterials: true
    @rotationOffset = if @rotated then Math.PI / 2 else 0
    @mesh.rotation.y = @rotationOffset

    loadHoverEffect @mesh, (=> @isVisible() and (@hasFocus or not gs.camera.focusMode)), (=> clickHandler @)

    @openCloseAnimationProgress = new SmoothValue 400, 0
    @openCloseAnimationProgress.addUpdateHandler (progress) =>
      @mesh.rotation.y = progress * Math.PI / 2 + @rotationOffset

  getFocusData: ->
    from = gs.player.currentRoom
    firstRoom = if from is @firstRoom then 0 else 1
    rot = if @rotated then 1 else 0
    return
      cameraPosition: CameraPosition[rot][firstRoom]
      cameraLookAt: FocusPosition[rot][firstRoom]
      playerPosition: PlayerPosition[rot][firstRoom]
      offset: @mesh.position.clone().add CenterOffset[rot]

  playOpenCloseAnimation: (goesUpOrRight) ->
    @playOpenAnimation goesUpOrRight
    setTimeout (=>
      @playCloseAnimation()
    ), 700

  playOpenAnimation: (goesUpOrRight) ->
    direction = 1
    if (goesUpOrRight) then direction = 1 else direction = -1
    @openCloseAnimationProgress.set direction

  playCloseAnimation: ->
    @openCloseAnimationProgress.set 0


  isVisible: =>
    @visible

  onInteract: (person) ->
    console.log(person)
    return unless @isVisible() and person.type == 'player'
    for direction, neighbourRoom of person.currentRoom.neighbourRooms
      return neighbourRoom.onPeek person if neighbourRoom?.getSharedDoorWith(person.currentRoom) == @


  onPersonEntersAdjacentRoom: (person) ->
    @visible = true if person.type == 'player'


  onPersonLeavesAdjacentRoom: (person) ->
    @visible = false if person.type == 'player'


module.exports = Door
