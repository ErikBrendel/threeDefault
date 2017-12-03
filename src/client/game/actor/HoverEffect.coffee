
SmoothValue = require '../../util/SmoothValue'

loadHoverEffect = (mesh, clickable = (-> true), clickHandler = (->), {
  speed = 600,
  r = 1
  g = 1
  b = 0
  baseIntensity = 0.05
  intensityIncrease = 0.05
  } = {}) ->
  mesh.userData.hoverEffectActive = false

  hoverPulse = new SmoothValue speed, 0

  oldEnterHandler = mesh.userData.mouseEnterHandler
  mesh.userData.mouseEnterHandler = ->
    oldEnterHandler?()
    return unless clickable()
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

  mesh.userData.clickHandler = ->
    clickHandler() if clickable()

  hoverPulse.addFinishHandler =>
    hoverPulse.set 1 - hoverPulse.get()

  hoverPulse.addUpdateHandler (hoverFade) =>
    mat = mesh.material
    mat = mat[0] if mat[0]?
    if mesh.userData.hoverEffectActive
      hoverIntensity = baseIntensity + hoverFade * intensityIncrease
      mat.emissive = (new THREE.Color r, g, b).multiplyScalar hoverIntensity
    else
      mat.emissive = new THREE.Color 0, 0, 0

module.exports = loadHoverEffect
