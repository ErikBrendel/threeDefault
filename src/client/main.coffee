# test main implementation

GameScene = require './game/GameScene'
LoadResources = require './config/resources'
initDescriptions = require './util/Description'


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
  initDescriptions()
  await LoadResources()
  gameInit()

window.addEventListener 'keydown', ->
  gs.exitHandler?()