# rBoard

rBoard is a kick-ass forum system built in Ruby on Rails. One of it's primary goals is being able to set it up quickly and easily, and still have it blow your mind with an awesome and stable feature set.

## How to get it up and running

In order to start using rBoard you should only have to clone the repository, and run `rake install`:

    git clone git://github.com/Radar/rboard.git rBoard
    cd rBoard

Then create a `config/database.yml` file for your database.

Then simply run:

    rake install # DO NOT FORGET THIS STEP
    
## Requirements

This app requires Sphinx which can be obtained from the Sphinx [website](http://sphinxsearch.com). Sphinx works with both MySQL and PostgreSQL. 

Alternatively, you could just comment out all the define_index lines in the models.

### Sphinx Installation

  1. download Sphinx
  2. extract it
  3. run `./configure && make && sudo make install` 
  4. `cd` to rBoard app folder
  5. run `rake ts:config && rake ts:in && rake ts:start`. This should start up the thinking sphinx daemon.

## OAQ (Occasionally Asked Questions)

  1. Why?

    Why not? I use forum systems every day and I figured the best way to learn more about Rails was to build one in it. rBoard's evolved into much, much more now and is my favourite project to work on.

  2. Who?

    One developer, so far. My name's Radar, but sometimes people call me Ryan or "dickhead". I wrote all of the code you see before you today.

  3. What?

    This is rBoard, a forum system built in Rails.

  4. How?

    To install it, type `rake install` and this should do all the magic for you.

  5. When (is it stable)?

    The `master` branch is usually kept in a stable manner whilst I tinker in my own personal branch, usually called `Radar`.

  6. OMG it is broken -- why!?!?

    If you have any problems, you can contact me [through GitHub](http://github.com/inbox/new/Radar) or by [emailing me](mailto:radarlistener@gmail.com)

  7. I love you.

    You can send money to `radarlistener@gmail.com` and I may love you back.