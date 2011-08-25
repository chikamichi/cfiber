require 'minitest/autorun'
require File.expand_path("../../lib/cfiber.rb",  __FILE__)

class TestFiberInstance < MiniTest::Unit::TestCase
  def setup
    @fiber = Fiber.new do |first_resume|
      puts first_resume
      puts Fiber.yield(puts(1))
      puts 'NEXT'
      puts Fiber.yield(puts(2))
      puts 'BYE'
    end
  end

  def test_public_api
    assert_respond_to @fiber.class, :new
    assert_respond_to @fiber.class, :yield
    assert_respond_to @fiber, :resume
  end

  def test_should_output_right
    @out, @err = capture_io do
      @fiber.resume(:one)
      @fiber.resume(:two)
      @fiber.resume(:three)
    end
    assert_match %r/one\n1\ntwo\nNEXT\n2\nthree\nBYE\n/, @out
  end

  def test_raise_for_dead_fiber
    capture_io do
      assert_raises(FiberError) do
        @fiber.resume(1)
        @fiber.resume(2)
        @fiber.resume(3)
        @fiber.resume(4) # should raise
      end
    end
  end

  #def test_should_know_wether_its_alive
    #capture_io do
      #puts @fiber.alive?
      #assert @fiber.alive?
      #@fiber.resume(1)
      #assert @fiber.alive?
      #@fiber.resume(2)
      #assert @fiber.alive?
      #@fiber.resume(3)
      #assert @fiber.alive?
      #@fiber.resume(4)
      #assert @fiber.alive?
    #end
  #end

  def test_should_be_able_to_transfer_control
    @fiber2 = Fiber.new do
      Fiber.yield(1)
      @fiber.transfer(2)
    end
    @fiber2.resume(:start)
  end
end
