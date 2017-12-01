# An Observable is something that an Observer can register itself on.
# Each Observer registers itself on "aspects", and is only notified
# when one of his aspects got updated.
# An observer can specify a notification message, that
# is passed to him on update.

class Observable
  constructor: ->
    @observers = []

  # @param observer the object to get notified
  # @param notification the object to send as a notification
  # @param aspects the changes to listen to, or undefined to listen to all
  attachObserver: (observer, notification, aspects) ->
    @observers.push
      observer: observer
      notification: notification
      aspects: aspects

  # remove the oldest occurrence of this observer
  detachObserver: (observer) ->
    index = -1
    for obs in @observers
      index++
      if obs.observer is observer
        return @observers.splice index, 1

  isObservedBy: (observer) ->
    for obs in @observers
      if obs.observer is observer
        return true
    return false

  # notify all the observers that listen to given aspects
  # pass no aspects to notify all observers
  notifyObservers: (aspect) ->
    for obs in @observers
      if not aspect? or not obs.aspects? or obs.aspects.includes aspect
        obs.observer.update obs.notification, aspect
    return


module.exports = Observable
