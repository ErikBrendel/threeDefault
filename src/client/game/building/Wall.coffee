{ Group } = THREE

class Wall extends Group
  constructor: (@angle, @open) ->
    super()
    @solid = @getSolidModel()
    @rotation.y = @angle
    @add @solid

  getSolidModel: -> AssetCache.getModel if @open then 'wall_open' else 'wall'

module.exports = Wall
