require File.expand_path("../../lib/cfiber.rb",  __FILE__)

def handle_fiber_error
  yield
rescue FiberError
  puts "cannot resume the fiber #{Fiber.current} anymore (FiberError)"
end

def section(string)
  puts
  puts string + " " + "-"*(79-(string.length))
  puts
  yield
  puts
  puts "OK/#{string}"
  puts
end

section "1. Use-case" do
  f = Fiber.new do |sym|
    puts self.inspect
    puts sym.inspect
    p(Fiber.yield 1)
    p(Fiber.yield 2)
    puts 'BYE'
  end

  handle_fiber_error do
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
end

section "2. Canonical example #1 for 1.9 Fibers" do
  fiber = Fiber.new do
    Fiber.yield 1
    2
  end

  handle_fiber_error do
    puts fiber.resume
    puts fiber.resume
    puts fiber.resume # will raise FiberError (hopefully!)
  end
end

section "3. Canonical example #2 for 1.9 Fibers" do
  fiber = Fiber.new do |first|
    second = Fiber.yield first + 2
  end

  handle_fiber_error do
    puts fiber.resume 10
    puts fiber.resume 14
    puts fiber.resume 18 # will raise FiberError (hopefully)
  end
end

section "4. Coroutines" do
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

  handle_fiber_error do
    puts
    f.transfer(100)          # resume f, do not know about g yet
  end
end
