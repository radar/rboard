# rBoard

rBoard is a kick-ass forum system built in Ruby on Rails. One of it's primary goals is being able to set it up quickly and easily, and still have it blow your mind with an awesome and stable feature set. It's now two years old as of March 10th, 2010.

If you're looking to integrate it into a site, please read the Integration section below.

It's currently under active development.

## How to get it up and running

In order to start using rBoard you should only have to clone the repository

    git clone git://github.com/radar/rboard.git rBoard
    cd rBoard
    sudo rake gems:install
    rake install

## Requirements

This app requires Sphinx which can be obtained from the Sphinx [website](http://sphinxsearch.com). Sphinx works with both MySQL and PostgreSQL. 

Alternatively, you could just set `SEARCHING = false` in _config/enviroments/development.rb_ or _config/enviroments/production.rb_, which will disable all thinking-sphinx code.

### Sphinx Installation

  1. download Sphinx
  2. extract it
  3. run `./configure && make && sudo make install` 

## Features

rboard has the following awesome things:

  * Runs on Rails 2.3 only (sorry!)
    * Can run on 2.x but requires a few lines to be removed.
  * Easy Internationalisation Support
  * Detailed permissions system
  * Categories (can be ordered)
  * Forums (can be ordered)
    * List topics with subject, author, replies, views and last post information
    * Can be restricted to certain user levels (visible to and topics created by)
    * Sub forums (infinitely. No, really. Try it.)
    * RSS Feeds
  * Topics
    * Locking
    * Sticky-ifying
    * Splitting
    * Merging
    * Subscriptable
    * Moveable
    * Editable
    * Deletable
    * Paginated (will_paginate)
    * RSS Feeds
  * Posts
    * Reply
    * Quote
    * Editable (it tracks these too!)
    * Deletable
    * Quick Reply
    * Code Highlighting (syntax gem)
    * Paginated (will_paginate)
  * Users
    * IP Tracking
    * Signatures
    * Member Lists
    * User Levels (Anonymous, User, Moderator & Administrator)
    * IP Banning
  * Ranks
    * Post dependent or custom
  * Themes
    * Upload your new theme directory into public/themes and go!
  * Private Messaging
  * Tracks read topics on a per-user basis
  * Searching (courtesy of ThinkingSphinx)


Puppies, Kittens, Rainbows and Unicorns sold separately. 

## OAQ (Occasionally Asked Questions)

  1. Why?

    Why not? I use forum systems every day and I figured the best way to learn more about Rails was to build one in it. rBoard's evolved into much, much more now and is my favourite project to work on.

  2. Who?

    One developer, so far. My name's Radar, but sometimes people call me Ryan or "dickhead". I wrote all of the code you see before you today.

  3. What?

    This is rBoard, a forum system built in Rails.

  4. How?

    To install it, go through the integrated installer inside the application itself. (Found at /install)

  5. When (is it stable)?

    The `master` branch is usually kept in a stable manner. I try to anyway. No guarantees about that.

  6. OMG it is broken -- why!?!?

    If you have any problems, you can log them in [the issue tracker](http://github.com/radar/rboard/issues) or you can contact me, either [through GitHub](http://github.com/inbox/new/radar) or by [emailing me](mailto:radarlistener@gmail.com).

  7. I love you.

    You can send money to `radarlistener@gmail.com` on Paypal or click the donate link and I will love you back.

## Integration

**Please note:** by no means is integration into an existing site easy. Rails apps are not made to be pluginable. I am waiting for Rails 3 so I can engine-ize rboard and ideally it'll Just Work. Until that magical day of pixies, unicorns, puppies and higher wages, I have no suggestions other than to try it yourself and write about it. I am available most of the time via email. I do not bite. We'll be BFF if you want to use my project.

**There is an easy non-integration way though**: Run rboard as a separate app on a subdomain for your app and point it to the same database. You may wish to customize the user model to use whatever method you authenticate with, since there's a high proabability you're using a separate method to what I am. This process is made easy by the inclusion of the `Rboard::UserExtension` and `Rboard::Permissions` modules into any `User` class. You should be able to just remove rboard's `User` class and replace it with your own if you see fit.

## Contributors

* Tom Unsworth
* Thomas Sinclair
* Bodaniel Jeanes
* Tore Darell
* rubygem
* fatalerrorx