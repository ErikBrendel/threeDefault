# Schedules person's actions in the game

class Scheduler
  constructor: (@persons...) ->
    @div = document.getElementById 'prio'

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
    newContent = ''
    max = @persons[@persons.length - 1].waitTime
    for line in [0 .. max]
      newContent += @persons.filter((p) -> p.waitTime is line).map((p) -> p.name).join('<br>')
      newContent += '<br>'

    @div.innerHTML = newContent



module.exports = Scheduler
