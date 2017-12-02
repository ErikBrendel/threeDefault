# Schedules person's actions in the game

class Scheduler
  constructor: (@persons...) ->

  step: ->
    @persons.sort (a, b) ->
      a.waitTime > b.waitTime
    shortestWaitTime = @persons[0].waitTime
    @wait shortestWaitTime
    @persons[0].onAction =>
      @step()

  wait: (amount) ->
    person.waitTime -= amount for person in @persons
    # TODO animation here



module.exports = Scheduler
