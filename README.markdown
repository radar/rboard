PLEASE RUN `RAKE INSTALL` WHEN TRYING THIS APPLICATION
====================================================

Yes it requires Sphinx which you can get from http://sphinxsearch.org and this works on MySQL and PostgreSQL. To install it download it, extract it, run ./configure && make && sudo make install and then in the rboard application run rake ts:config && rake ts:in && rake ts:start. This should start up the thinking sphinx daemon.

Alternatively, you could just comment out all the define_index lines in the models.

1. Why?

Why not? I use forum systems every day and I figured the best way to learn more about Rails was to build one in it. Rboard's evolved into much, much more now and is my favourite project to work on.

2. Who?

One developer, so far. My name's Radar, but sometimes people call me Ryan or "dickhead". I wrote all of the code you see before you today.

3. What?

This is rboard, a forum system built in Rails.

4. How?

To install it, type rake install and this should do all the magic for you.

5. When (is it stable)?

Master is usually kept in a stable manner whilst I tinker in my own personal branch also called Radar.

6. It's broken.

Any problems, you can contact me through my user on Github (Radar) or radarlistener@gmail.com

7. I love you.

You can send money to radarlistener@gmail.com and I may love you back.
