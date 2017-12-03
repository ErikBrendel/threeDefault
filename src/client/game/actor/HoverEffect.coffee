
SmoothValue = require '../../util/SmoothValue'

loadHoverEffect = (mesh, showHover = -> true) ->
  mesh.userData.hoverEffectActive = false

  hoverPulse = new SmoothValue 600, 0

  oldEnterHandler = mesh.userData.mouseEnterHandler
  mesh.userData.mouseEnterHandler = ->
    oldEnterHandler?()
    return unless showHover()
    mesh.userData.hoverEffectActive = true
    hoverPulse.set 1

  resetHover = ->
    mesh.userData.hoverEffectActive = false
    hoverPulse.set 0
  mesh.userData.resetHover = resetHover

  oldLeaveHandler = mesh.userData.mouseLeaveHandler
  mesh.userData.mouseLeaveHandler = ->
    oldLeaveHandler?()
    resetHover()


  hoverPulse.addFinishHandler =>
    hoverPulse.set 1 - hoverPulse.get()
  hoverPulse.addUpdateHandler (hoverFade) =>
    mat = mesh.material
    mat = mat[0] if mat[0]?
    if mesh.userData.hoverEffectActive
      hoverIntensity = 0.05 + hoverFade * 0.05
      mat.emissive = (new THREE.Color 1, 1, 0).multiplyScalar hoverIntensity
    else
      mat.emissive = new THREE.Color 0, 0, 0

module.exports = loadHoverEffect
