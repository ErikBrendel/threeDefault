
SmoothValue = require '../../util/SmoothValue'

loadHoverEffect = (mesh, showHover = -> true) ->
  mesh.userData.hoverEffectActive = false

  hoverPulse = new SmoothValue 600, 0

  mesh.userData.mouseEnterHandler = ->
    return unless showHover()
    mesh.userData.hoverEffectActive = true
    hoverPulse.set 1

  mesh.userData.mouseLeaveHandler = ->
    mesh.userData.hoverEffectActive = false
    hoverPulse.set 0

  hoverPulse.addFinishHandler =>
    hoverPulse.set 1 - hoverPulse.get()
  hoverPulse.addUpdateHandler (hoverFade) =>
    if mesh.userData.hoverEffectActive
      hoverIntensity = 0.05 + hoverFade * 0.05
      mesh.material[0].emissive = (new THREE.Color 1, 1, 0).multiplyScalar hoverIntensity
    else
      mesh.material[0].emissive = new THREE.Color 0, 0, 0

module.exports = loadHoverEffect
