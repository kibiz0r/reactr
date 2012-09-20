module Reactr
  class Streamer < Stream
    include Broadcastable

    def initialize(&setup_block)
      @lazy_setup = setup_block

      (@@streams ||= []) << self
    end

    def <<(value)
      process_next value
    end

    def done
      process_done
    end

    def error(error = nil)
      process_error error
    end

    def start
      if @lazy_setup && !@started
        @started = true
        begin
          @lazy_setup[self]
        rescue => error
          self.error error
        end
      end
      self
    end
  end
end
