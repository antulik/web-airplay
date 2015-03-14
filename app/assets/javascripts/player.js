var PlayingTrack = Backbone.Model.extend({
  defaults: {
    "duration": 0
  }
});

Player = Backbone.Model.extend({

  PLAYSTATE_PLAYING: 'playing',
  PLAYSTATE_PAUSED: 'paused',
  PLAYSTATE_STOPPED: 'stopped',

  defaults: {
    "_position":  0,
    "_duration": 0,
    "_playState": "stopped",
    "playingTrack": new PlayingTrack,
    "playing": false
  },

  constructor: function() {
    Backbone.Model.apply(this, arguments);
    this.on('change:_position', function(model, val) {
      this.trigger('change:position', val);
    });

    this.on('change:_duration', function(model, val) {
      var current_track = this.get('playingTrack');

      if (current_track.get('duration') != val) {
        var new_track = new PlayingTrack({
          duration: val
        });
        this.set('playingTrack', new_track);
      }
      this.trigger('change:playingTrack', new_track);
    });

    this.on('change:_playState', function(model, val) {
      this.trigger('change:playState', val);
    });
  },

  playState: function() {
    return this.get('_playState');
  },

  position: function(new_position) {
    if (new_position) {
      $.post('/player/seek', { seconds: new_position } );
    }
    return this.get('_position');
  },

  playingTrack: function() {
    return this.get('playingTrack');
  },

  shuffle: function() {},
  volume: function() {},

  previous: function() {},
  togglePause: function() {
    if (this.get('_playState') == this.PLAYSTATE_PLAYING) {
      this.set('_playState', this.PLAYSTATE_PAUSED);
      $.post('/player/pause')
    } else {
      this.set('_playState', this.PLAYSTATE_PLAYING);
      $.post('/player/resume')
    }

  },
  next: function() {},

  url: function() {
    return '/backbone_info'
  }
});


