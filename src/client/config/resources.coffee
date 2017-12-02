require '../util/ResourceCache'

models = [
  'wall',
  'wall_open',
  'ground',
  'player',
  'guard',
  'door',
  'objects/stairs',
  'objects/safe',
]

module.exports = ->
  #TODO: Set THREE.DefaultLoadingManager listeners for progress reports
  new Promise (resolve) ->
    AssetCache.loadModel(name) for name in models
    THREE.DefaultLoadingManager.onLoad = ->
      resolve()
