
SmoothValue = require '../../util/SmoothValue'

loadHoverEffect = (mesh, clickable = (-> true), clickHandler = (->), {
  speed = 600,
  r = 1
  g = 1
  b = 0
  baseIntensity = 0.05
  intensityIncrease = 0.1
  } = {}) ->
  mesh.userData.hoverEffectActive = false
  mat = mesh.material
  mat = mat[0] if mat[0]?
  defaultEmissiveColor = mat.emissive
  defaultEmissiveIntensity = mat.emissiveIntensity

  hoverPulse = new SmoothValue speed, 0

  oldEnterHandler = mesh.userData.mouseEnterHandler
  mesh.userData.mouseEnterHandler = ->
    oldEnterHandler?()
    return unless clickable()
    mesh.userData.hoverEffectActive = true
    hoverPulse.set 1

  updateMat = (mat2) ->
    unless mat2 is mat
      mat = mat2
      defaultEmissiveColor = mat.emissive
      defaultEmissiveIntensity = mat.emissiveIntensity

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
    updateMat mat
    if mesh.userData.hoverEffectActive
      hoverIntensity = baseIntensity + hoverFade * intensityIncrease
      mat.emissiveIntensity = 1
      mat.emissive = defaultEmissiveColor.clone().lerp((new THREE.Color r, g, b), hoverIntensity)
    else
      mat.emissiveIntensity = defaultEmissiveIntensity
      mat.emissive = defaultEmissiveColor

module.exports = loadHoverEffect
