# test main implementation

GameScene = require './game/GameScene'
RotatingIcoSphere = require './game/RotatingIcoSphere'
LoadResources = require './config/resources'


gameInit = ->
  gameScene = new GameScene ->
    console.log 'update!'
  window.gs = gameScene

  gameScene.addAxisHelper 1
  gameScene.appendChildFullscreen()
  gameScene.animation()

# export to the browser console

window.onload = ->
  await LoadResources()
  gameInit()
