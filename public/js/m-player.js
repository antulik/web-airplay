var metronomik = window.metronomik || {};

metronomik.player = function (containerId, player) {

  var $container = $("#" + containerId),
      $html = $("html"),
      currentPlayState = player.playState(),
      currentPosition = player.position(),
      currentTrack = player.playingTrack(),
      currentShuffle = player.shuffle(),
      currentVolume = player.volume(),
      preMuteVolume = -1,
      sliding = false,
      timelineSliding = false,
      volumeSliding = false,
      svgNS = "http://www.w3.org/2000/svg",
      svgPrevious = makeSVGElem({ w: 13, h: 13, shapes: [{ type: 'polygon', points: '0,6.5 7,0.006 7,4.645 13,0.006 13,12.994 7,8.355 7,12.994' }] }),
      svgNext = makeSVGElem({ w: 13, h: 13, shapes: [{ type: 'polygon', points: '13,6.5 6,0.006 6,4.645 0,0.006 0,12.994 6,8.355 6,12.994' }] }),
      svgPlay = makeSVGElem({ w: 13, h: 13, shapes: [{ type: 'polygon', points: '2.5,12.994 10.5,6.5 2.5,0.006' }] }),
      svgPause = makeSVGElem({ w: 13, h: 13, shapes: [{ type: 'rect', x: 8, w: 4, h: 13 }, { type: 'rect', x: 1, w: 4, h: 13 }] }),
      svgShuffle = makeSVGElem({ w: 13, h: 13, shapes: [{ type: 'path', d:
          'M9.422,8.966c-3.14,0-4.017-1.119-5.062-2.424c1.045-1.306,1.922-2.426,5.062-2.426V5.82l2.864-2.864\
          L9.422,0.092v1.705c-4.187,0-5.115,1.622-6.271,3.045C2.328,4.211,1.642,3.751,0,3.751V6.07c0.87,0,1.45,0.17,1.929,0.471\
          C1.45,6.841,0.87,7.012,0,7.012V9.33c1.642,0,2.328-0.46,3.151-1.091c1.156,1.424,2.084,3.046,6.271,3.046v1.704l2.864-2.863\
          L9.422,7.262V8.966z' }]}),
      svgLogo = makeSVGElem({ w: 17, h: 15, shapes: [{ type: 'path', d:
          'M16.996,14.344c0,0.323-0.213,0.432-0.477,0.239l-3.281-2.42c-0.26-0.194-0.473-0.615-0.473-0.939V6.301\
          c0-0.021-0.002-0.043-0.004-0.062c-0.029-0.28-0.248-0.389-0.514-0.244L9.051,7.75C8.9,7.832,8.698,7.871,8.5,7.865\
          C8.3,7.871,8.099,7.832,7.948,7.75L4.751,5.994C4.486,5.85,4.267,5.958,4.238,6.238c-0.002,0.02-0.004,0.041-0.004,0.062v4.923\
          c0,0.324-0.214,0.745-0.476,0.939l-3.28,2.42c-0.261,0.192-0.475,0.084-0.475-0.239V3.505c0-0.325,0.214-0.748,0.475-0.939\
          l3.28-2.421C3.89,0.048,4.066,0,4.238,0c0.17,0,0.34,0.049,0.471,0.145l3.283,2.421C8.13,2.667,8.316,2.715,8.5,2.707\
          c0.184,0.008,0.37-0.04,0.51-0.141l3.279-2.421C12.42,0.049,12.592,0,12.762,0c0.174,0,0.346,0.048,0.477,0.145l3.281,2.421\
          c0.264,0.191,0.477,0.614,0.477,0.939V14.344z' }]}),
      svgVolume = makeSVGElem({ w: 13, h: 13, shapes: [{ type: 'polygon', points: '6.75,4 2.75,4 2.75,9 6.667,9 9.749,12 9.749,1' }] });

  function makeSVGElem(svgData) {

    var svg = document.createElementNS(svgNS, "svg:svg");

    svg.setAttributeNS(null, 'width', svgData.w);
    svg.setAttributeNS(null, 'height', svgData.h);

    for (var i = 0; i < svgData.shapes.length, shapeData = svgData.shapes[i]; ++i) {

      var shape;

      switch (shapeData.type) {

        case 'polygon':

          shape = document.createElementNS(svgNS, 'polygon');
          shape.setAttributeNS(null, 'points', shapeData.points);

          break;

        case 'rect':

          shape = document.createElementNS(svgNS, 'rect');
          shape.setAttributeNS(null, 'x', shapeData.x);
          shape.setAttributeNS(null, 'width', shapeData.w);
          shape.setAttributeNS(null, 'height', shapeData.h);

          break;

        case 'path':

          shape = document.createElementNS(svgNS, 'path');
          shape.setAttributeNS(null, 'd', shapeData.d);

          break;

      }

      if (shapeData.cls) {
        shape.setAttribute('class', shapeData.cls);
      }

      svg.appendChild(shape);

    }

    return svg;
  }

  function secsToMinsSecs(secs) {
    var retMins = parseInt(secs / 60),
        retSecs = secs % 60;
    return [retMins < 10 ? "0" + retMins : String(retMins), ":", retSecs < 10 ? "0" + retSecs : String(retSecs)].join("");
  }

  function handleSliding(el, evt, updateCallback, stopCallback) {

    sliding = true;

    var $el = $(el).addClass('m-slide-active');

    function update(updateEvt) {

      var relativePos = updateEvt.pageX - $el.offset().left,
          elementWidth = $el.width();

      if (relativePos >= elementWidth) {
        updateCallback(1);
      } else if (relativePos <= 0) {
        updateCallback(0);
      } else {
        updateCallback(relativePos / $el.width());
      }


    }

    $html.addClass('m-sliding').on("mousemove", update).on("mouseup", function (upEvt) {

      sliding = false;

      $el.removeClass('m-slide-active');

      $html.off("mousemove mouseup").removeClass('m-sliding');

      if (stopCallback) {
        stopCallback.apply();
      }
    });

    update(evt);

  }

  // ------------------------------------------------------------------
  // Construct Player
  // ------------------------------------------------------------------

  $container.empty();

  var $player = jQuery(document.createElement('div'))
      .attr({ 'class': 'm-player' })
      .appendTo($container);

  //----------------------------------------------------
  // Time text
  //----------------------------------------------------

  var $timeText = jQuery(document.createElement('div'))
      .attr({ 'class': 'm-time-text cf' })
      .appendTo($player);

  var $timeTextElapsed = jQuery(document.createElement('span'))
      .attr({ 'class': 'm-time-text-elapsed l' })
      .text("00:00")
      .appendTo($timeText);

  var $timeTextTotal = jQuery(document.createElement('span'))
      .attr({ 'class': 'm-time-text-total r' })
      .text("00:00")
      .appendTo($timeText);


  //----------------------------------------------------
  // Timeline
  //----------------------------------------------------

  var $timeline = jQuery(document.createElement('div'))
      .attr({ 'class': 'm-timeline' })
      .appendTo($player);

  var $timelineSlider = jQuery(document.createElement('div'))
      .attr({ 'class': 'm-timeline-slider' })
      .appendTo($timeline);

  var $timelineElapsed = jQuery(document.createElement('div'))
      .attr({ 'class': 'm-timeline-elapsed' })
      .appendTo($timelineSlider);

  var $timelineMarker = jQuery(document.createElement('div'))
      .attr({ 'class': 'm-timeline-marker' })
      .appendTo($timelineSlider);


  //----------------------------------------------------
  // Controls
  //----------------------------------------------------

  var $controls = jQuery(document.createElement('div'))
      .attr({ 'class': 'm-controls cf' })
      .appendTo($player);


  //----------------------------------------------------
  // Previous | Play/Pause | Next
  //----------------------------------------------------

  var $previous = jQuery(document.createElement('button'))
      .attr({ 'class': 'm-previous m-btn l', type: 'button' })
      .append(svgPrevious)
      .appendTo($controls);

  var $playToggle = jQuery(document.createElement('button'))
      .attr({ 'class': 'm-playToggle m-btn l', type: 'button' })
      .append(svgPlay)
      .appendTo($controls);

  var $next = jQuery(document.createElement('button'))
      .attr({ 'class': 'm-next m-btn l', type: 'button' })
      .append(svgNext)
      .appendTo($controls);


  //----------------------------------------------------
  // Shuffle
  //----------------------------------------------------

  var $shuffleToggle = jQuery(document.createElement('button'))
      .attr({ 'class': 'm-shuffleToggle m-btn l', type: 'button' })
      .append(svgShuffle)
      .appendTo($controls);


  //----------------------------------------------------
  // Logo
  //----------------------------------------------------

  var $logo = jQuery(document.createElement('button'))
      .attr({ 'class': 'm-logo m-btn l', type: 'button' })
      .append(svgLogo)
      .appendTo($controls);


  //----------------------------------------------------
  // Volume (on the right hand side)
  //----------------------------------------------------

  var $volume = jQuery(document.createElement('div'))
      .attr({ 'class': 'm-volume r cf' })
      .appendTo($controls);

  var $volumeButton = jQuery(document.createElement('button'))
      .attr({ 'class': 'm-volumeToggle l', type: 'button' })
      .append(svgVolume)
      .appendTo($volume);

  var $volumeSlider = jQuery(document.createElement('div'))
      .attr({ 'class': 'm-volume-slider' })
      .appendTo($volume);

  var $volumeLevel = jQuery(document.createElement('div'))
      .attr({ 'class': 'm-volume-level' })
      .appendTo($volumeSlider);

  var $volumeMarker = jQuery(document.createElement('span'))
      .attr({ 'class': 'm-marker m-volume-marker' })
      .appendTo($volumeSlider);






  // ------------------------------------------------------------------
  // Player Interactions
  // ------------------------------------------------------------------

  $previous.on("click", function (e) {
    player.previous();
  });

  $playToggle.on("click", function (e) {
    player.togglePause();
  });

  $next.on("click", function (e) {
    player.next();
  });

  $shuffleToggle.on("click", function (e) {
    player.shuffle(currentShuffle ^= true);
  });

  $logo.on("click", function (e) {
    window.open("http://www.metronomik.com/Projects/RdioPlayerControls");
  });

  $timelineSlider.on("mousedown", function (e) {

    var currentPos;

    timelineSliding = true;

    handleSliding($timeline, e, function (updateData) {


      currentPos = Math.floor(updateData * currentTrack.get('duration'));

      // Expects seconds
      handlePosition(currentPos);

    }, function () {

      timelineSliding = false;

      player.position(currentPos);

    });

  });

  $volumeSlider.on('mousedown', function (e) {

    volumeSliding = true;

    handleSliding($volumeSlider, e, function (updateData) {

      // Expects decimal
      handleVolume(updateData);

    }, function () {

      volumeSliding = false;

      player.volume(currentVolume);

    });

  });

  $volumeButton.on('click', function () {

    if (preMuteVolume === -1) {
      preMuteVolume = currentVolume;
      handleVolume(0);
    } else {
      handleVolume(preMuteVolume);
      preMuteVolume = -1;
    }

    player.volume(currentVolume);

  });

  $html.keypress(function (e) {
    if (e.which == 32) {
      player.togglePause();
    }
  });

  // ------------------------------------------------------------------
  // Event handlers
  // ------------------------------------------------------------------

  function handlePlayState(playState) {

    currentPlayState = playState;

    if (playState === player.PLAYSTATE_PLAYING) {

      $playToggle.html(svgPause);
    }

    else if (playState === player.PLAYSTATE_PAUSED) {

      $playToggle.html(svgPlay);

    }

    else if (playState === player.PLAYSTATE_STOPPED) {

      $playToggle.html(svgPlay);

    }

    else { throw "Strange playstate... " + playState }

  }

  function handlePosition(position) {

    var duration = currentTrack.get('duration');

    if (position <= duration && position > -1) {

      currentPosition = position || 0;

      $timeTextElapsed.text(secsToMinsSecs(position));

      $timelineMarker.css('left', Math.max(0, ((position / duration) * $timelineSlider.width()) - $timelineMarker.width()) + 'px');

      $timelineElapsed.css('width', ((position / duration) * 100) + '%');

    }

  };

  function handlePlayingTrack(track) {

    currentTrack = track;
    $timeTextTotal.text(secsToMinsSecs(currentTrack.get('duration') || 0));
    handlePosition(0);

  }

  function handleShuffle(shuffle) {

    currentShuffle = shuffle;

    $shuffleToggle.toggleClass('m-shuffle', shuffle);

  }

  function handleVolume(volume) {

    if (volume <= 1 && volume >= 0) {

      currentVolume = volume;

      $volumeButton.toggleClass('m-volume-mute', currentVolume === 0);
      $volumeButton.toggleClass('m-volume-low', currentVolume > 0 && currentVolume <= 0.33);
      $volumeButton.toggleClass('m-volume-med', currentVolume > 0.33 && currentVolume <= 0.66);
      $volumeButton.toggleClass('m-volume-high', currentVolume > 0.66);

      $volumeMarker.css('left', Math.max(0, (volume * $volumeSlider.width()) - $volumeMarker.width()) + 'px');

      $volumeLevel.css('width', (volume * 100) + '%');

    }
  }


  // ------------------------------------------------------------------
  // Events
  // ------------------------------------------------------------------

  player.on('change:playState', handlePlayState);
  player.on('change:playingTrack', handlePlayingTrack);
  player.on('change:shuffle', handleShuffle);
  player.on('change:volume', handleVolume);
  player.on("change:position", function (position) {
    if (!timelineSliding) {
      handlePosition(position);
    }
  });


  // ------------------------------------------------------------------
  // Init
  // ------------------------------------------------------------------

  handleShuffle(currentShuffle);
  handleVolume(currentVolume);

  if (currentTrack) {
    handlePlayingTrack(currentTrack);
    handlePosition(currentPosition);
    handlePlayState(currentPlayState);
  }

}
