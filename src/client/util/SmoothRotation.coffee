

THREE = null
THREE_LOAD = require 'bundle-loader?name=three!three'
THREE_LOAD (three) -> THREE = three


SmoothValue = require 'util/SmoothValue'

class SmoothRotation extends SmoothValue
  constructor: (lerpTime, value, smoothness) ->
    super lerpTime, value, smoothness

  lerp: (a, b, x) ->
    r = a.clone()
    r.slerp b, x
    return r


module.exports = SmoothRotation