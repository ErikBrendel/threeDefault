#to synchronize callback-based getting of data that should only get computed once

class CallbackSyncProxy
  constructor: (@callbackFunction) ->
    @data = undefined
    @callbacks = []
    @lock = false

  get: (callback) ->
    return if not callback?
    return callback @data if @data?

    @callbacks.push callback

    if not @lock
      @lock = true
      @callbackFunction (response) =>
        @data = if response? then response else true
        while @callbacks.length > 0
          @callbacks.pop() response

module.exports = CallbackSyncProxy