# test main implementation

GameScene = require './GameScene'
RotatingIcoSphere = require './RotatingIcoSphere'


ico = new RotatingIcoSphere 5, 1, ICO_COLOR

gameScene = new GameScene ->
  console.log 'update!'

gameScene.add ico
gameScene.addAxisHelper 10

# export to the browser console
window.gs = gameScene

window.onload = ->
  gameScene.appendChildFullscreen()
  gameScene.animation()
