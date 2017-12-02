require '../util/ResourceCache'

models = [
  'wall',
  'wall_open',
  'floor'
]

loadResources = ->
  #TODO: Set THREE.DefaultLoadingManager listeners for progress reports
  new Promise (resolve) ->
    THREE.DefaultLoadingManager.onLoad = ->
      resolve
    AssetCache.loadModel(name) for name in models
