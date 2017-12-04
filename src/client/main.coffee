# test main implementation

GameScene = require './game/GameScene'
RotatingIcoSphere = require './game/RotatingIcoSphere'
LoadResources = require './config/resources'
require './util/DescriptionHelper'


gameInit = ->
  gameScene = new GameScene (deltaTime) ->
    document.getElementById('fps').innerText = Math.floor(1000.0 / deltaTime)

  window.gs = gameScene

  #gameScene.addAxisHelper 1
  gameScene.appendChildFullscreen()
  gameScene.animation()
  gameScene.scheduler.step()

# export to the browser console

window.onload = ->
  await LoadResources()
  gameInit()

window.addEventListener 'keydown', ->
  gs.exitHandler?()