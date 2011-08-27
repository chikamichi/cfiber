require File.expand_path("../../lib/cfiber.rb",  __FILE__)

#RUN_ONLY = /Coroutines/

@register_examples = []

# Register an example and runs it.
#
# Define a RUN_ONLY constant, either as an integer, an array of integers,
# a range or a regexp to filter examples by index or title.
#
# @param [#to_s] title the example's description
def register_example(title, &block)
  @register_examples << [title, block]
  run = Proc.new do
    puts
    puts @register_examples.length.to_s + ". " + title + " " + "-"*(75-(title.length))
    puts
    handle_fiber_error { yield }
    puts
    puts "OK/#{title}"
    puts
  end

  if !defined?(RUN_ONLY) ||
     (RUN_ONLY.is_a?(Array) && RUN_ONLY.to_a.include?(@register_examples.length)) ||
     (RUN_ONLY.is_a?(Regexp) && title.match(RUN_ONLY))
    run.call
  end
end

# Used to rescue from fibers errors so next examples are runned.
def handle_fiber_error
  yield
rescue FiberError
  puts "cannot resume the fiber #{Fiber.current} anymore (FiberError)"
end

register_example "Most basic use-case" do
  f = Fiber.new do |sym|
    puts self.inspect
    puts sym.inspect
    p(Fiber.yield 1)
    p(Fiber.yield 2)
    puts 'BYE'
  end

  puts
  puts "# f.resume('HI')"
  p(f.resume 'HI')

  puts
  puts "# f.resume(:first_time)"
  p(f.resume :first_time)

  puts
  puts "# f.resume(:second_time)"
  p(f.resume :second_time)

  puts
  puts "# f.resume(4)"
  p(f.resume 4)
end

register_example "Canonical example #1 for 1.9 Fibers" do
  fiber = Fiber.new do
    Fiber.yield 1
    2
  end

  puts fiber.resume
  puts fiber.resume
  puts fiber.resume # will raise FiberError (hopefully!)
end

register_example "Canonical example #2 for 1.9 Fibers" do
  fiber = Fiber.new do |first|
    second = Fiber.yield first + 2
  end

  puts fiber.resume 10
  puts fiber.resume 14
  puts fiber.resume 18 # will raise FiberError (hopefully)
end

register_example "Coroutines" do
  f = g = nil

  f = Fiber.new do |x|     # capture @yield for f
    puts "F1: #{x}"        #
    x = g.transfer(x+1)    # should f.yield and g.resume
    puts "F2: #{x}"        #
    x = g.transfer(x+1)    # should f.yield and g.resume
    puts "F3: #{x}"
  end

  g = Fiber.new do |x|     # capture @yield for g
    puts "G1: #{x}"
    x = f.transfer(x+1)    # should g.yield and f.resume
    puts "G2: #{x}"
    x = f.transfer(x+1)    # should g.yield and f.resume
  end

  f.transfer(100)          # resume f, do not know about g yet
end

register_example "Coroutines II" do
  n = 37
  machines = []
  5.times do |i|
    machines[i] = Fiber.new do
      j = 5
      while n > 1 && j > 0 do
        puts n
        n -= 1
        j -= 1
      end
      machines[(i+1)%5].transfer if n > 1
      puts "done"
    end
  end

  machines.first.transfer
end

register_example "Coroutines III" do
  # this works!
  g = Fiber.new { |x|
    puts "G1: #{x}"
    x = Fiber.yield(x+1)
    puts "G2: #{x}"
    x = Fiber.yield(x+1)
  }

  f = Fiber.new { |x|
    puts "F1: #{x}"
    x = g.resume(x+1)
    puts "F2: #{x}"
    x = g.resume(x+1)
    puts "F3: #{x}"
  }

  f.resume(100)
end
