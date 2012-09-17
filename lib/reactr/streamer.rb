module Reactr
  class Streamer < Stream
    def initialize(&setup_block)
      @lazy_setup = setup_block
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

    def subscribe(streamer_or_handlers, override_handlers = {})
      handlers = if streamer_or_handlers.is_a? Streamer
                   {
                     each: lambda { |v| streamer_or_handlers << v },
                     success: lambda { streamer_or_handlers.success },
                     failure: lambda { |e| streamer_or_handlers.failure e }
                   }.merge override_handlers
                 else
                   streamer_or_handlers
                 end
      super(handlers).tap { start }
    end

    def start
      if @lazy_setup
        @lazy_setup[self]
        @lazy_setup = nil
      end
      self
    end
  end
end
