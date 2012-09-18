module Reactr
  class Stream
    include Reactr::Streamable

    def initialize(streamer = nil, &setup_block)
      @streamer = if block_given?
                    Streamer.new &setup_block
                  else
                    streamer
                  end
    end

    def subscribe(streamer_or_handlers, override_handlers = {})
      each, success, failure = if streamer_or_handlers.is_a? Streamer
                                 s, o = streamer_or_handlers, override_handlers
                                 [
                                   o[:each]._? { lambda { |v| s << v } },
                                   o[:success]._? { lambda { s.done } },
                                   o[:failure]._? { lambda { |e| s.error e } }
                                 ]
                               else
                                 [
                                   streamer_or_handlers[:each],
                                   streamer_or_handlers[:success],
                                   streamer_or_handlers[:failure]
                                 ]
                               end

      eaches << each if each
      successes << success if success
      failures << failure if failure

      start

      Reactr::Subscription.new self, each, success, failure
    end
    
    def start
      if @streamer
        @streamer.subscribe(
          each: lambda { |v| process_next v },
          success: lambda { process_done },
          failure: lambda { |e| process_error e }
        )
      end
      self
    end

    def ended?
      !!@ended
    end

    def to_a
      [].tap do |values|
        each do |value|
          values << value
        end
      end
    end

    def cancel_subscription(subscription)
      eaches.delete subscription.each
      successes.delete subscription.success
      failures.delete subscription.failure
    end

    protected

    def end_stream
      raise StreamEndedError if ended?
      @ended = true
    end

    def process_next(value)
      raise StreamEndedError if ended?

      eaches.each do |each| # lol
        each.call value
      end
    end

    def process_done
      end_stream

      successes.each do |success|
        success.call
      end
    end

    def process_error(error)
      end_stream

      failures.each do |failure|
        failure.call error
      end
    end

    def eaches
      @eaches ||= []
    end

    def successes
      @successes ||= []
    end

    def failures
      @failures ||= []
    end
  end
end
