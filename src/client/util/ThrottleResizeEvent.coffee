# Defining a new Event called 'optimizedResize',
# that gets fired on Resize, but only once per frame
# see https://developer.mozilla.org/de/docs/Web/Events/resize

throttle = (type, name, obj) ->
  obj = obj or window
  running = false

  func = ->
    if running
      return
    running = true
    requestAnimationFrame ->
      obj.dispatchEvent new CustomEvent(name)
      running = false
      return
    return

  obj.addEventListener type, func
  return

### init - you can init any event ###
throttle 'resize', 'optimizedResize'