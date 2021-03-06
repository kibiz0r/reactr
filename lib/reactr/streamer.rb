AllStreams = [] unless defined? AllStreams

module Reactr
  class Streamer < Stream
    include Broadcastable

    def initialize(&setup_block)
      @lazy_setup = setup_block
      AllStreams << self
      @stream_index = AllStreams.size - 1
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
        @lazy_setup[self]
      end
      self
    end
  end
end

