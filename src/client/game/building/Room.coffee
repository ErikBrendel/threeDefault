class Room
  constructor: (scene, position) ->

    translation = new THREE.Vector3( position.x * 4, 0, position.y * 4 )

    up = AssetCache.getModel 'wall_open'
    up.castShadow = true
    up.receiveShadow = true
    up.position.copy translation
    scene.add up

    right = AssetCache.getModel 'wall_open'
    right.castShadow = true
    right.receiveShadow = true
    right.position.copy translation
    right.rotation.y = Math.PI / 2
    scene.add right

    down = AssetCache.getModel 'wall_open'
    down.castShadow = true
    down.receiveShadow = true
    down.position.copy translation
    down.rotation.y = Math.PI
    scene.add down

    left = AssetCache.getModel 'wall_open'
    left.castShadow = true;
    left.receiveShadow = true;
    left.position.copy translation
    left.rotation.y = Math.PI * 1.5
    scene.add left

    floor = AssetCache.getModel 'floor'
    floor.castShadow = true
    floor.receiveShadow = true
    floor.position.copy translation
    scene.add floor

module.exports = Room
