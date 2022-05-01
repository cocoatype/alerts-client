# Cocoatype Twitch Alerts

## Overview

This codebase is the code that runs alerts and overlays on the [Cocoatype Twitch stream](https://twitch.tv/cocoatype), but with several [copyrighted elements](#missing-elements) removed. As such, it will not build out of the box. However, it should still be able to provide sample code for implementing similar effects in a different codebase.

This project has a dependency on my [Twitch Chat Swift package](https://git.pado.name/twitch/chat).

Yes, it's AppKit. Sorry.

## Code

### Extensions

No overview available.

### Alert Window

The window that contains every other view. It is a full-screen window that floats over every full-screen Space on your Mac. Other than that, it's nothing special; just a standard window.

### Application

No overview available.

### Chat

Displays notifications when chatters post in my channel. This includes support for Twitch emotes (though animated emotes do not yet animate), as well as chatters' self-selected username colors. There is no support yet for other chat-based addons such as bits or highlighted chat.

### Device Overlays

Displays a floating overlay showing the screen of a connected iOS device. Mousing over (under?) the overlay causes it to become translucent to show the screen behind the overlay. 

AppleScript support allows you to hide, show, or full-screen the overlay. I use this support to add these commands to an Elgato Stream Deck.

### Native Alerts

This is a work in progress to replace the Streamlabs web-based alerts with a native display, similar to the work done for chat. It is not currently used. Finishing this support requires a server component, which will be open-sourced when it is complete.

### Project Quicksilver

This was a celebration for my 100th Twitch follower. Instead of playing the normal follower alert, it played the cannon section of [Tchaikovsky's 1812 Overture](https://youtu.be/VbxgYlcNxE8?t=708), complete with visual effects and pulsing overlays. It was pretty awesome.

I don't remember why it's called Project Quicksilver.

### Twitch

The code in here that starts with "OAuth" is useful! The rest isn't! Ignore it!

(The OAuth code is used to get access tokens for the chat support.)

### Web Views

This section used to be the bulk of the project; it uses web views with transparent backgrounds to display Streamlabs widgets. The only remaining web view is alerts; other widgets have been replaced with native counterparts.

## Missing Elements

### Environment Variables

There are some environment variables used throughout the codebase. You can set these in the Xcode scheme editor, under Run > Arguments.

`ALERT_BOX_URL` is a URL to a [Streamlabs Alert Box widget](https://streamlabs.com/desktop-widgets/alert-box). You can get this in the Streamlabs dashboard.

`APP_CLIENT_ID` is a client ID for a Twitch app. You can get this in the [Twitch developer console](http://dev.twitch.tv).

`APP_CLIENT_SECRET` is a client secret for a Twitch app. You can get this in the [Twitch developer console](http://dev.twitch.tv).

`CHAT_REFRESH_TOKEN` is a refresh token for your Twitch user account with the `chat:read` scope. The easiest way to get this is with the [Twitch CLI](https://dev.twitch.tv/docs/cli): `twitch token -u -s chat:read`

### Assets

#### Device Frames

These are device frames displayed around the video overlays when using the full screen mode. They are modified versions of Apple's device frames (though likely for devices no longer available).

#### Overture

`overture.m4a` is a recording of the cannons section of the 1812 Overture for Project Quicksilver.

#### Sounds

These are alert sounds played when you gain a new follower or subscriber.
