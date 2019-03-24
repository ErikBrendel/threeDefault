# test main implementation

initDescriptions = require './util/Description'
GameScene = require './game/GameScene'
LoadResources = require './config/resources'


gameInit = ->
  gameScene = new GameScene (deltaTime) ->
    document.getElementById('fps').innerText = Math.floor(1000.0 / deltaTime)

  hideDescription()
  #gameScene.addAxisHelper 1
  gameScene.appendChildFullscreen()
  gameScene.animation()
  gameScene.scheduler.step()

# export to the browser console

window.onload = ->
  initDescriptions()
  await LoadResources()
  showDescription
    header: 'Loading scene...'
  gameInit()

window.addEventListener 'keydown', (event) ->
  gs.exitHandler?() if event.keyCode is 27 or event.keyCode is 32