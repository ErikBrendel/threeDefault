require '../util/ResourceCache'
require '../util/MusicHelper'

models = [
  'wall',
  'wall_open',
  'ground',
  'player',
  'guard',
  'door',
  'questionMark',
  'objects/stairs',
  'objects/safe',
  'objects/safe_door',
  'objects/safe_handle',
  'objects/safe_lock',
  'objects/item_Coins',
  'objects/item_GoldIngot',
  'objects/item_SuitCase',
  'objects/BankNotePile',
  'objects/camera',
  'objects/monitor',
  'objects/laser',
  'objects/alarm',
]

sounds = [
  'move',
  'lock_tick',
  'lock_correct',
  'door_squeak',
  'door_wheel',
  'door_open',
  'door_close',
  'collect_coin',
]

music = [
  'fast',
  'slow',
]

module.exports = ->
  #TODO: Set THREE.DefaultLoadingManager listeners for progress reports
  new Promise (resolve) ->
    AssetCache.loadModel name for name in models
    AssetCache.loadSound name for name in sounds
    AssetCache.loadMusic name for name in music
    THREE.DefaultLoadingManager.onLoad = ->
      resolve()
