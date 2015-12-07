![logo](http://f.cl.ly/items/0146322v3V2I1T3U1J3f/logo_128.png)

WebAirplay
===========

On iPhone you can play any video from Internet on Airplay device. WebAirplay gives you exactly that but on your desktop.

![webairplay screenshot](http://f.cl.ly/items/332B0R1x30303p1G3i0l/Screenshot%202015-03-15%2013.37.10_2.png)

## Help Needed!!

- [Browser Extension](https://github.com/antulik/web-airplay/issues/1)
- [Mac OS application loader](https://github.com/antulik/web-airplay/issues/2)

## Why?

If you would like to watch video from your desktop you can use builtin Airplay functionality
and mirror or extend your desktop. Problems with such solution is lower quality and audio delays.
In addition you can't use your desktop for other tasks while you are doing that.

For watching movies you can use something like [Beamer](http://beamer-app.com/) app.

WebAirplay is alternative to Beamer for streaming online videos like Youtube, Vimeo and others from your desktop to Apple TV.

## Download

Download the latest version on [release page](https://github.com/antulik/web-airplay/releases)

## API

* GET **/api_v1/devices** - list airplay devices

```json
[ 
  {
    id: 0,
    name: 'device.name',
  }
]
```

* GET **/api_v1/refresh** - refresh devices list

* POST **/api_v1/devices/:device_id/pause** - pause playback

* POST **/api_v1/devices/:device_id/seek** - scroll video to **:seconds** from start 

* POST **/api_v1/devices/:device_id/resume** - resume playback on the device if paused

* POST **/api_v1/devices/:device_id/play_url** - play direct video url on that device

* GET **/api_v1/devices/:device_id/playback** - returns current play info

```json
{
  "duration":134.97666931152344,
  "loadedTimeRanges":[
    {"duration":7.535599546, "start":32.422733787}
  ],
  "playbackBufferEmpty":true,
  "playbackBufferFull":false,
  "playbackLikelyToKeepUp":true,
  "position":32.92290115356445,
  "rate":1.0,
  "readyToPlay":true,
  "seekableTimeRanges":[
    {"duration":134.97666666666666,"start":0.0}
  ],
  "playState": "playing"
}
```

* GET **/api_v1/items** - returns play queue

```json
[
  {
    "id": 0,
    "url": '',
    "title": '',
    "author": '',
    "playback_urls": [],
    "created_at": ''
  }
]
```

* POST **/api_v1/items** - add **:url** to play queue

* DELTE **/api_v1/items/:id** - delete item from play queue
 

## todo

- Fix bookmark on https pages
- Refresh airplay devices list
- Add vimeo support
- Add any html5 video playback support
- Simultaneous multiple device playback
- Local video files support
- Sign app so MacOS doesn't complaing
- Put on Appstore

## Changelog

### next
- file size decreased
- api

### 0.5.2 - 2015/03/16
- fixed bug when styles weren't loaded

### 0.5.1 - 2015/03/15
- updated new version checker
- interface switched to progress bar
- refresh devices button
- video list is saved

### v0.5 - 2015/03/14
- Added video queue
- switched to new framework (from cuba to rails)
- bundled ruby
- added icon
- web view replace with normal browser link

### v0.4 - 2014/08/22
- Seek position

### v0.3 - 2014/03/18
- Fixed bookmark on https pages. (new bookmark link required)

### v0.2 - 2014/02/09
- Application is more stable
- New version reminder

### v0.1 - 2014/02/03
- First release. Hooray! Day 0.
- Play youtube videos
- Play from bookmark link
- Mac OS App
