class Fiber
  begin
    require 'logg'
    include Logg::Machine

    log.as(:debug) do |msg|
      unless ENV['CFIBER_DEBUG'].to_i == 0
        puts "[DEBUG] #{msg}"
      end
    end

    log.debug 'output ready'
  rescue LoadError
  end
end
