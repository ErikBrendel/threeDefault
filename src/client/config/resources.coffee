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
  'objects/safe_lock',
  'objects/item_Coins',
  'objects/item_GoldIngot',
  'objects/item_SuitCase',
  'objects/camera',
  'objects/laser',
  'objects/alarm',
]

sounds = [
  'move',
]

module.exports = ->
  #TODO: Set THREE.DefaultLoadingManager listeners for progress reports
  new Promise (resolve) ->
    AssetCache.loadModel name for name in models
    AssetCache.loadSound name for name in sounds
    THREE.DefaultLoadingManager.onLoad = ->
      resolve()
