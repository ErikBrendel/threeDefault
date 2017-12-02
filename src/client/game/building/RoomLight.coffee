

class RoomLight extends THREE.PointLight
  constructor: ->
    super('#000000', 1, 10, 2, false)
    @position.set 1, 1, 1
    @castShadow = false
    #@shadow.mapSize.width = 256;
    #@shadow.mapSize.height = 256;

  activate: ->
    @color = new THREE.Color '#fff0ca'


module.exports = RoomLight