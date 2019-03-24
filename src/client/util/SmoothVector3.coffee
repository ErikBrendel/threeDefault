SmoothValue = require 'util/SmoothValue'

class SmoothVector3 extends SmoothValue
  constructor: (lerpTime, value, smoothness) ->
    super lerpTime, value, smoothness

  isSameTarget: (newTarget) ->
    false

  lerp: (a, b, x) ->
    return new THREE.Vector3(
      super(a.x, b.x, x),
      super(a.y, b.y, x),
      super(a.z, b.z, x)
    )


module.exports = SmoothVector3