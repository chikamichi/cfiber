CFiber is [Fibers](http://rubydoc.info/stdlib/core/1.9.2/Fiber) implemented using continuations, using the native Ruby [Continuation](http://rubydoc.info/stdlib/core/1.9.2/Continuation) class.

Experimental! It is based on [tmm1's work](https://gist.github.com/48802).

## Installation

Not available as a gem yet. You should clone this repository.

You may build and install a local gem running `gem build cfiber.gemspec && gem install cfiber*.gem` though.

## Usage

Run `ruby spec/cfiber_spec.rb`. Run and **read** `ruby examples/use_cases.rb`. Then play with `Fiber`.

In a Ruby console, `require ./lib/cfiber.rb` (when inside cfiber's root directory) or `require 'cfiber'` (if you built and installed a local gem).

By installing the [Logg](http://github.com/chikamichi/logg) gem, you'll gain DEBUG output. Disable by setting `CFIBER_DEBUG` to 0:

    CFIBER_DEBUG=0 ruby examples/use_cases.rb

## TODO

* coroutines using #transfer do not work atm.
* #alive? implementation is challenging

## Interesting readings

* http://rubydoc.info/stdlib/core/1.9.2/Fiber
* http://rubydoc.info/stdlib/core/1.9.2/Continuation
* http://masanjin.net/blog/fibers
* http://www.intertwingly.net/blog/2005/04/13/Continuations-for-Curmudgeons
* http://www.davidflanagan.com/2007/08/coroutines-via-fibers-in-ruby-19.html
* http://pragdave.blogs.pragprog.com/pragdave/2007/12/pipelines-using.html
