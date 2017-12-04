SmoothValue = require './SmoothValue'

class MusicHelper
  constructor: ->
    @activeTrack = null
    @nextTrack = null
    @tracks = {}
    @fading = false

  getTrack: (track) ->
    @tracks[track] = AssetCache.getMusic track unless @tracks[track]?
    @tracks[track]

  startAudio: (track) ->
    @activeTrack?.stop()
    @activeTrack = @getTrack(track)
    @activeTrack.play()

  fadeTo: (track, time = 2000) ->
    unless @fading
      @fading = true
      @activeVolume = @activeTrack.getVolume() if @activeTrack?
      @nextTrack = @getTrack(track)
      @nextVolume = @nextTrack.getVolume()
      @nextTrack.setVolume 0
      @nextTrack.play()
      fader = new SmoothValue time, 0
      fader.addUpdateHandler (value) =>
        console.debug(value)
        @activeTrack.setVolume (1 - value) * @activeVolume if @activeTrack?
        @nextTrack.setVolume value * @nextVolume
      fader.set 1
      fader.addFinishHandler =>
        @activeTrack.setVolume @activeVolume if @activeTrack?
        @activeTrack.stop() if @activeTrack?
        @activeTrack = @nextTrack
        @activeTrack.setVolume @nextVolume
        @nextTrack = null
        @fading = false

window.Jukebox = new MusicHelper
