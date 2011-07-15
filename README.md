# Service Queue

Experimental zeromq task broker for possible use with GitHub Services.

The code is pretty hackish and untested still.  You can set it up like
this:

1. Install zeromq (with homebrew or equivalent).
2. Install node 0.4.8, npm 1.0.x, and coffee-script.
3. With npm, install zeromq.
4. Setup ruby 1.8 or 1.9 with the zeromq gem.

Start the broker:

    $ coffee broker.coffee

Start a worker:

    $ ruby worker.rb

If you want to start multiple workers, give them unique names:

    $ ruby worker.rb 1
    $ ruby worker.rb 2
    $ ruby worker.rb 3

Start up a requester to submit a job:

    $ ruby requester.rb

Like workers, you can start up multiple requesters with unique names:

    $ ruby requester.rb 1
    $ ruby requester.rb 2
    $ ruby requester.rb 3

This amazing service will add exclamations to your input!

    >> abc
    => abc!

More to come.
