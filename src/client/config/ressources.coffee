require '../util/ResourceCache'

models = [
  'wall',
  'wall_open',
  'floor'
]

loadResources = ->
  new Promise (resolve) ->
    THREE.DefaultLoadingManager.onLoad = ->
      resolve
    AssetCache.loadModel(name) for name in models
