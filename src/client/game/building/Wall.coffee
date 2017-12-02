{ Group } = THREE

class Wall extends Group
  constructor: (@angle, @open) ->
    super()
    @solid = @getSolidModel()
    @door = @getDoorModel() if @open
    @rotation.y = @angle
    @add @solid

  getSolidModel: -> AssetCache.getModel if @open then 'wall_open' else 'wall'

  getDoorModel: ->

module.exports = Wall
