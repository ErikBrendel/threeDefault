# A SmoothValue encapsulates a value that smoothly trends against a target value

class SmoothValue

  # @param lerpTime how long it takes to fade to a newly set target value
  # @param value the initial value of this SmoothValue
  # @param smoothness 0=linear, 1=smoothstep, 2=smootherstep, default=1
  constructor: (@lerpTime, @value, @smoothness = 1) ->
    @target = @value
    @oldTarget = @value
    @oldTime = Date.now()
    @updateHandlers = []
    @progressListener = []
    @finishHandlers = []
    @updateLoopRunning = false

  addUpdateHandler: (newHandler) ->
    @updateHandlers.push newHandler
    @updateLoop()

  addProgressListener: (newListener) ->
    @progressListener.push newListener
    @updateLoop()

  addFinishHandler: (newHandler) ->
    @finishHandlers.push newHandler

# set a new target for this SmoothValue
# it starts a fading there immediately, starting from the current value
  set: (newTarget) ->
    if not @target?
      @target = newTarget
      @oldTarget = newTarget
      @updateLoop()
      return
    if @isSameTarget newTarget
      @target = newTarget
      @update()
      @updateLoop()
      return
    @update()
    @oldTarget = @value
    @oldTime = Date.now()
    @target = newTarget
    @updateLoop()

#aborts the current animation, lets the value rest where it currently is
  halt: ->
    currentValue = @get()
    @oldTarget = currentValue
    @target = undefined
    @oldTime = Date.now() - 2 * @lerpTime

  #aborts everything
  destroy: ->
    @updateHandlers = []
    @progressListener = []
    @finishHandlers = []
    @target = undefined
    @value = undefined
    @halt()

  # change the data without interfering the smooth progress
  inject: (objectChanger) ->
    @get()
    @target = objectChanger @target
    @oldTarget = objectChanger @oldTarget
    @value = objectChanger @value
    handler @value for handler in @updateHandlers

# return true, if the new value is the 'same' as the old one (so that no one would notice the difference)
  isSameTarget: (newTarget) ->
    return Math.abs(@target - newTarget) < 0.001

# return the current value
  get: ->
    @update() if @target?
    @value

# will execute all update handlers once a frame until the target value is reached
  updateLoop: ->
    return if not @target?
    return if @updateLoopRunning
    return if (@updateHandlers.length + @finishHandlers.length + @progressListener.length) is 0
    return if not @isAnimating()
    @updateLoopRunning = true
    loopFunc = =>
      value = @get()
      if value?
        handler value for handler in @updateHandlers
      if @isAnimating()
        window.requestAnimationFrame => loopFunc()
      else
        @updateLoopRunning = false
        handler() for handler in @finishHandlers
        listener 1 for listener in @progressListener
    loopFunc()

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

    listener smoothed for listener in @progressListener

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