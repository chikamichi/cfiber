CFiber is [Fibers](http://rubydoc.info/stdlib/core/1.9.2/Fiber) implemented using continuations, using the native Ruby [Continuation](http://rubydoc.info/stdlib/core/1.9.2/Continuation) class.

Experimental! It is based on [tmm1's work](https://gist.github.com/48802).

## Usage

Run `ruby spec/cfiber_spec.rb`. Run and **read** `ruby examples/use_cases.rb`. Then play with `Fiber`.

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
