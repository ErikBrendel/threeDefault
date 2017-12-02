# every geometry inside a room is a RoomObject

SmoothValue = require '../../../util/SmoothValue'

class RoomObject
  constructor: (@type, @room, clickHandler) ->
    @mesh = AssetCache.getModel "objects/#{@type}"
    @mesh.userData.clickHandler = => clickHandler @
    @loadHoverEffect()
    @room.add @mesh

  loadHoverEffect: ->
    @hoverEffectActive = false
    @mesh.userData.mouseEnterHandler = => @onMouseEnter()
    @mesh.userData.mouseLeaveHandler = => @onMouseLeave()
    @hoverPulse = new SmoothValue 600, 0
    @hoverPulse.addFinishHandler =>
      @hoverPulse.set 1 - @hoverPulse.get()
    @hoverPulse.addUpdateHandler (hoverFade) =>
      if @hoverEffectActive
        hoverIntensity = 0.05 + hoverFade * 0.05
        @mesh.material[0].emissive = (new THREE.Color 1, 1, 0).multiplyScalar hoverIntensity
      else
        @mesh.material[0].emissive = new THREE.Color 0, 0, 0

  onMouseEnter: ->
    console.log "HOVERING!"
    @hoverEffectActive = true
    @hoverPulse.set 1

  onMouseLeave: ->
    @hoverEffectActive = false
    @hoverPulse.set 0

  onInteract: (person) ->
  onEnter: (person, oldRoom) ->
  onLeave: (person, newRoom) ->


module.exports = RoomObject
