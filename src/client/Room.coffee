class Room
  constructor: (scene, position) ->

    translation = new THREE.Vector3( position.x * 4, 0, position.y * 4 )

    up = AssetCache.getModel 'wall'
    up.position.add translation
    scene.add up

    right = AssetCache.getModel 'wall_open'
    right.position.add translation
    right.rotation.x = Math.PI / 2
    scene.add right

    down = AssetCache.getModel 'wall_open'
    down.position.add translation
    down.rotation.x = Math.PI
    scene.add down

    left = AssetCache.getModel 'wall'
    left.position.add translation
    left.rotation.x = Math.PI * 1.5
    scene.add left

    floor = AssetCache.getModel 'floor'
    floor.position.add translation
    scene.add floor

module.exports = Room
