
info_container = undefined
info_header = undefined
info_text = undefined
info_value = undefined
info_cost = undefined

hide = (elem) ->
  elem.classList.add 'hidden'
show = (elem) ->
  elem.classList.remove 'hidden'

hideDescription = ->
  hide info_container

showDescription = ({header, text = '', value, cost} = {}) ->
  if not header?
    hideDescription()
    return

  show info_container
  info_header.innerText = header
  info_text.innerHTML = text

  if value?
    info_value.innerText = "Item value: #{value}"
    show info_value
  else
    info_value.innerText = ''
    hide info_value

  cost = cost() if typeof cost is 'function'
  if cost?
    info_cost.innerText = "Action Cost: #{cost}"
    show info_cost
  else
    info_cost.innerText = ''
    hide info_cost

load = ->
  info_container = document.getElementById('info-container')
  info_header = document.getElementById('info-header')
  info_text = document.getElementById('info-text')
  info_value = document.getElementById('info-value')
  info_cost = document.getElementById('info-cost')

window.hideDescription = hideDescription
window.showDescription = showDescription
module.exports = load
