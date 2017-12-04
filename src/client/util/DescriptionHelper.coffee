class DescriptionHelper
  constructor: () ->
    @boxElement = document.getElementById 'info-container'
    @titleElement = document.getElementById 'info-header'
    @detailsElement = document.getElementById 'info-text'
    @valueElement = document.getElementById 'info-value'
    @costElement = document.getElementById 'info-cost'

window.Description = new DescriptionHelper