# Schedules person's actions in the game

class Scheduler
  constructor: (@persons...) ->
    @bars = document.getElementById 'prioBars'

  step: ->
    @persons.sort (a, b) ->
      a.waitTime > b.waitTime
    shortestWaitTime = @persons[0].waitTime
    @wait shortestWaitTime, =>
      @persons[0].onAction =>
        [@persons[0], @persons[@persons.length - 1]] = [@persons[@persons.length - 1], @persons[0]]
        @step()

  wait: (amount, waitingDone) ->
    @updateUI()
    return waitingDone() if amount <= 0
    person.waitTime -= 1 for person in @persons
    setTimeout (=> @wait amount - 1, waitingDone), 200

  updateUI: ->
    maxWait = @persons
      .map (p) -> p.waitTime
      .reduce (a, b) -> Math.max a, b
    unless @persons.length is 2
      console.warn 'Not exactly 2 persons to schedule! Could break!'
    for person in @persons
      bar = document.getElementById "prioBar-#{person.type}"
      bar.style.left = "#{-640 + 64 * (maxWait + 1)}px"
      avatar = document.getElementById "avatar-#{person.type}"
      avatar.style.right = "#{64 * person.waitTime}px"




module.exports = Scheduler
