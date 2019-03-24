# Schedules person's actions in the game

SmoothValue = require '../util/SmoothValue'

class Scheduler
  constructor: (@persons...) ->
    @bars = document.getElementById 'prioBars'

    @avatarFade = {}
    @boebbelBars = []

    for type in ['player', 'guard']
      do (type) =>
        smooth = new SmoothValue 100
        @avatarFade[type] = smooth
        smooth.addUpdateHandler (avatarPos) ->
          document.getElementById("avatar-#{type}").style.right = "#{avatarPos}px"
        @boebbelBars.push document.getElementById "prioBar-#{type}"

    @maxWaitFade = new SmoothValue 400
    @maxWaitFade.addUpdateHandler (boebbelBarPos) =>
      bar.style.left = "#{boebbelBarPos}px" for bar in @boebbelBars

  step: ->
    @wait =>
      @persons[0].onAction =>
        [@persons[0], @persons[@persons.length - 1]] = [@persons[@persons.length - 1], @persons[0]]
        @step()

  wait: (waitingDone) ->
    @updateUI()
    return waitingDone() if @getCurrentMin() <= 0
    person.waitTime -= 1 for person in @persons
    setTimeout (=> @wait waitingDone), 200

  getCurrentMin: ->
    @persons.sort (a, b) ->
      a.waitTime > b.waitTime
    return @persons[0].waitTime

  updateUI: ->
    maxWait = @persons
      .map (p) -> p.waitTime
      .reduce (a, b) -> Math.max a, b
    unless @persons.length is 2
      console.warn 'Not exactly 2 persons to schedule! Could break!'
    for person in @persons
      @maxWaitFade.set -640 + 64 * (maxWait + 1)
      @avatarFade[person.type].set 64 * person.waitTime
      document.getElementById("avatar-#{person.type}").classList
        .toggle "#{person.type}Avatar-active", person is @persons[0]




module.exports = Scheduler
