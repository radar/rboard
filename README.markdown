# rBoard

rBoard is a kick-ass forum system built in Ruby on Rails. One of it's primary goals is being able to set it up quickly and easily, and still have it blow your mind with an awesome and stable feature set. It's now one year old as of March 10th, 2009.

If you're looking to integrate it into a site, please read the Integration section below.

It's currently under active development.

## How to get it up and running

In order to start using rBoard you should only have to clone the repository

    git clone git://github.com/radar/rboard.git rBoard
    cd rBoard
    
Start up the site in your deployment of choice and complete the installation procedure (by accessing the site in your web browser of choice) and you should be ready to go!
## Requirements

This app requires Sphinx which can be obtained from the Sphinx [website](http://sphinxsearch.com). Sphinx works with both MySQL and PostgreSQL. 

Alternatively, you could just comment out or remove the define_index block in the post model.

### Sphinx Installation

  1. download Sphinx
  2. extract it
  3. run `./configure && make && sudo make install` 
  4. `cd` to rBoard app folder
  5. run `rake ts:config && rake ts:in && rake ts:start`. This should start up the thinking sphinx daemon.
  
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

rBoard works as a stand-alone solution as well as a drop-in solution for your site's forum needs. All the user model specific code has been moved to a module to ensure that this process is made easier. You have two options:

  1. Use the pre-existing user model (integrate your site into rBoard). 
  
  2. Use your own user model (integrate rBoard into your site). In user model you just have to write `include Rboard::UserExtension`. The relevant authentication system code has also been modularized into *lib/rboard/auth.rb* and must be included into the ApplicationController of your site like this: `include Rboard::Auth`. Please be aware that this module will override any `current_user` or `logged_in?` methods you have defined anywhere else. 
  
If you wish to use a different authentication system other than Restful Authentication then remove the user model (*app/models/user.rb*) and replace it with your own whilst not forgetting to `include Rboard::UserExtension`, the AuthenticatedSystem module (*lib/authenticated_system.rb*) and the AuthenticatedTestHelper module (*lib/authenticated_test_helper.rb*)
  

