class Fiber
  begin
    require 'logg'
    include Logg::Machine

    log.as(:debug) do |msg|
      unless (defined?(CFIBER_DEBUG) && CFIBER_DEBUG == 0) || ENV['CFIBER_DEBUG'].to_i == 0
        puts "[DEBUG] #{msg}"
      end
    end

    log.debug 'output ready'
  rescue LoadError
    def self.log
      Object.new.extend( Module.new do
        def debug(*args, &block)
          # do nothing
        end
      end)
    end
    def log
      self.class.log
    end
  end
end
