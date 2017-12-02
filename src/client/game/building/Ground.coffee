{ Group } = THREE

class Ground extends Group
  constructor: ->
    super()
    @model = AssetCache.getModel 'ground'
    @add @model

module.exports = Ground
