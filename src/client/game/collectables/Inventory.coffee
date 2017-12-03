# an Inventory to mix into other classes like Persons or Safes

class Inventory
  constructor: (objects...) ->
    @contents = []
    @addContents(objects...)

  addContents: (objects...) ->
    @contents.push(objects...)

  onReceiveObject: (newObject) ->
    @contents.push newObject

  onObjectTaken: (object) ->
    objectIndex = @contents.indexOf object
    console.log objectIndex
    if objectIndex > -1
      @contents.splice objectIndex, 1

  findObjects: (finder) ->
    @contents.filter(finder)

  size: ->
    @contents.length

  changeContentOwner: (newOwner) ->
    @contents.forEach((item) -> item.changeOwner newOwner)

module.exports = Inventory
