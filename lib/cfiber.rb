# Based on this 1.8 try: https://gist.github.com/48802

class FiberError < StandardError; end
class Fiber
  require 'continuation'
  require './lib/ext/null_object'
  require './lib/cfiber/debug'

  attr_reader :alive

  # Like an implicit Fiber.yield, the first one: it acts the same as
  # Fiber.yield but for the &block call!
  #
  def initialize(&block)
    @alive = true
    unless @yield = callcc { |cc| cc }
      @args = Fiber.current.instance_exec(@args, &block)
      @resume.call
    end
    self.class.log.debug "initial state for #{self}: #{@yield}"
  end

  def self.current
    Thread.current[:__cfiber]
  end

  # Fiber.yield delegates to the current fiber instance #yield method.
  #
  # In order to retrieve the current fiber, a reference should have been
  # stored. It's thread-safe for it uses a Thread.current-local variable to
  # store the ref.
  #
  def self.yield(*args)
    Fiber.current.yield(*args)
  end

  # Wake a fiber up, passing its args to the resumed block.
  #
  # First, it captures a new continuation to save a breakpoint, then it yields
  # its arguments. Along the way, a reference for the current fiber object is
  # stored within the current thread.
  #
  def resume(*args)
    if @resume = callcc { |cc| cc }
      Fiber.current = self
      @args = args.size > 1 ? args : args.first
      @yield.call # the first #resume call will trigger the #initialize block
                  # execution, until a call to Fiber.yield is made inside the
                  # very block; whereas subsequent #resume calls will resume
                  # the block's execution from the last Fiber.yield point.
    else
      log.debug "outputing inside #resume for #{self}"
      @args
    end
  rescue NoMethodError => e # undefined method call for nil:NilClass, that is
    @alive = false
    raise FiberError, "dead fiber #{Fiber.current} called"
  end

  # Pause the current fiber, while yielding its args in the fiber's context.
  #
  # First, it captures a new continuation to save a breakpoint, then it yields
  # its arguments ("passing along any arguments that were passed to it").
  #
  def yield(*args)
    if @yield = callcc { |cc| cc }
      @args = args.size > 1 ? args : args.first
      @resume.call
    else
      log.debug "outputing inside #yield for #{self}"
      @args
    end
  end

  # Useful to implement coroutines.
  #
  # @example
  #   f = g = nil
  #
  #   f = Fiber.new do |x|
  #     puts "F1: #{x}"
  #     x = g.transfer(x+1)
  #     puts "F2: #{x}"
  #     x = g.transfer(x+1)
  #     puts "F3: #{x}"
  #   end
  #
  #   g = Fiber.new do |x|
  #     puts "G1: #{x}"
  #     x = f.transfer(x+1)
  #     puts "G2: #{x}"
  #     x = f.transfer(x+1)
  #   end
  #
  #   f.transfer(100)
  #
  # FIXME: the tricky part is init. In the example above, f.transfer(100)
  # triggers f.resume(100), which in turns reach g.transfer(101). This
  # triggers g.yield(f.resume(101)) but this is wrong. One must atomically
  # pause (yield) g and resume f.
  #
  def transfer(*args)
    if Fiber.current.nil?
      self.resume(*args)
    else
      log.debug ""
      log.debug "pausing current fiber #{Fiber.current}, resuming to #{self}"
      #self.resume(Fiber.yield(*args))
      Fiber.yield(self.resume(*args))
    end
  end

  def alive?
    Fiber.current.instance_variable_get(:@alive)
  end

  private

  def self.current=(fiber)
    Thread.current[:__cfiber] = fiber
  end
end
