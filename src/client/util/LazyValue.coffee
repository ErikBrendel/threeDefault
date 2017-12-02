#to synchronize callback-based getting of data that should only get computed once

class LazyValue
  constructor: (@dataGenerator) ->
    @data = undefined
    @done = false

  get: () ->
    return @data if @done

    @data = @dataGenerator()
    @done = true
    return @data

module.exports = LazyValue