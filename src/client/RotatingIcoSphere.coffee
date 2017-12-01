# Demo object: rotating icosphere in wireframe mode

class RotatingIcoSphere
  constructor: (size, subdivisions, color) ->
    geometry = new THREE.IcosahedronGeometry size, subdivisions
    material = new THREE.MeshBasicMaterial
      color: color
      wireframe: true
      wireframeLinewidth: 2
    @mesh = new THREE.Mesh geometry, material
    @mesh.userData.updateCallback = (deltaTime) => @update deltaTime

  update: (deltaTime) ->
    @mesh.rotation.x += deltaTime * 0.00005
    @mesh.rotation.y += deltaTime * 0.0001


module.exports = RotatingIcoSphere