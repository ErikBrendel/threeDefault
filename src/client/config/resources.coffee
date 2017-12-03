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
  'objects/safe_door',
  'objects/safe_handle',
  'objects/item_Coins',
  'objects/item_GoldIngot',
]

module.exports = ->
  #TODO: Set THREE.DefaultLoadingManager listeners for progress reports
  new Promise (resolve) ->
    AssetCache.loadModel(name) for name in models
    THREE.DefaultLoadingManager.onLoad = ->
      resolve()
