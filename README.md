CFiber is [Fibers](http://rubydoc.info/stdlib/core/1.9.2/Fiber) implemented using continuations, using the native Ruby [Continuation](http://rubydoc.info/stdlib/core/1.9.2/Continuation) class.

Experimental! It is based on [tmm1's work](https://gist.github.com/48802).

# Synopsis

Continuations in Ruby are like time-machine engineers. They let you take snapshots of your runtime environment, and jump (back) to a particular "save point" at any time. Fibers are a way to pause and resume an execution frame by hand. It is all about jumping back and forth between two states, so with some smart design, continuations should let us achieve this pattern. The project is an attempt at implementing the Ruby 1.9 Fiber API using only continuations, which API is made of only two methods:

* `callcc`, which stands for *Call With Current Continuation*; it allows for capturing the runtime state and associate a pending block to it;
* `call`, which have us jump back in time and perform the block in the context of the current runtime, where "current" really means "the captured state".

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

### Doc

* http://rubydoc.info/stdlib/core/1.9.2/Fiber
* http://rubydoc.info/stdlib/core/1.9.2/Continuation

### Continuations

* http://www.intertwingly.net/blog/2005/04/13/Continuations-for-Curmudgeons
* http://gnuu.org/2009/03/21/demystifying-continuations-in-ruby/
* http://onestepback.org/articles/callcc/
* http://www.ibm.com/developerworks/java/library/os-lightweight9/

### Fibers

* http://masanjin.net/blog/fibers
* http://www.davidflanagan.com/2007/08/coroutines-via-fibers-in-ruby-19.html
* http://pragdave.blogs.pragprog.com/pragdave/2007/12/pipelines-using.html
