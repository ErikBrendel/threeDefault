SmoothValue = require 'util/SmoothValue'

class SmoothRotation extends SmoothValue
  constructor: (lerpTime, value, smoothness) ->
    super lerpTime, value, smoothness

  lerp: (a, b, x) ->
    r = a.clone()
    r.slerp b, x
    return r


module.exports = SmoothRotation