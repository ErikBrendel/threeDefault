module.exports = [
  {
    floorSize: {x: 4, y: 4}
    rooms:
      stairs: 1,
      safe: 1,
      camera: 2,
      laser: 3,
      default: 9
    layout:
      """
      +-+-+-+-+
      |   |   |
      + +-+ +-+
      |     | |
      + +-+ + +
      | | |   |
      + + +-+ +
      |       |
      +-+-+-+-+
      """
  },{
    floorSize: {x: 4, y: 4}
    rooms:
      stairs: 1,
      safe: 1,
      camera: 3,
      laser: 5,
      default: 7
    layout:
      """
      +-+-+-+-+
      | |     |
      + + +-+ +
      |   |   |
      +-+ + +-+
      | | |   |
      + + + +-+
      |       |
      +-+-+-+-+
      """
  },{
    floorSize: {x: 4, y: 4}
    rooms:
      stairs: 1,
      safe: 2,
      camera: 4,
      laser: 6,
      default: 4
    layout:
      """
      +-+-+-+-+
      |     | |
      +-+ +-+ +
      |       |
      + +-+-+ +
      |       |
      + +-+ +-+
      | |     |
      +-+-+-+-+
      """
  }
]