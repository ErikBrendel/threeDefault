# A Function to shuffle arrays

shuffle = (array) ->
  counter = array.length
  # While there are elements in the array

  while counter > 0
    # Pick a random index
    index = Math.floor(Math.random() * counter)

    counter--
    # And swap the last element with it
    temp = array[counter]
    array[counter] = array[index]
    array[index] = temp

module.exports = shuffle