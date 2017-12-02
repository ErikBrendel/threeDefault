# test main implementation

GameScene = require './game/GameScene'
RotatingIcoSphere = require './game/RotatingIcoSphere'
LoadResources = require './config/resources'


gameInit = ->
  ico = new RotatingIcoSphere 5, 1, ICO_COLOR
  gameScene = new GameScene ->
    console.log 'update!'
  window.gs = gameScene

  gameScene.add ico
  gameScene.addAxisHelper 10
  gameScene.appendChildFullscreen()
  gameScene.animation()

# export to the browser console

window.onload = ->
  await LoadResources()
  gameInit()
