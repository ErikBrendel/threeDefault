# A SmoothValue encapsulates a value that smoothly trends against a target value

class SmoothValue

  # @param lerpTime how long it takes to fade to a newly set target value
  # @param value the initial value of this SmoothValue
  # @param smoothness 0=linear, 1=smoothstep, 2=smootherstep, default=1
  constructor: (@lerpTime, @value, @smoothness) ->
    @target = @value
    @oldTarget = @value
    @oldTime = Date.now()
    @smoothness = 1 if not @smoothness?

  # set a new target for this SmoothValue
  # it starts a fading there immediately, starting from the current value
  set: (newTarget) ->
    if not @target?
      @target = newTarget
      @oldTarget = newTarget
      return
    return if newTarget is @target
    @update()
    @oldTarget = @value
    @oldTime = Date.now()
    @target = newTarget

  # return the current value
  get: ->
    @update() if @target?
    @value

  # true while the value changes
  isAnimating: ->
    deltaTime = Date.now() - @oldTime
    return deltaTime <= @lerpTime

  # re-calculate the current value
  update: ->
    deltaTime = Date.now() - @oldTime
    if deltaTime > @lerpTime
      @value = @target
      return

    progress = deltaTime / @lerpTime
    smoothed = @smoothValue progress

    @value = @lerp @oldTarget, @target, smoothed

  # take a value between 0 and 1 and smooth it
  smoothValue: (x) ->
    if @smoothness is 0
      return x
    if @smoothness is 1
      return x * x * (3.0 - 2.0 * x)
    if @smoothness is 2
      return x * x * x * (x * (x * 6.0 - 15.0) + 10.0)
    console.error 'unknown smoothness: ' + @smoothness
    return x

  # perform a lerp operation
  lerp: (a, b, x) ->
    b * x + a * (1.0 - x)

module.exports = SmoothValue