module Reactr
  class Stream
    include Reactr::Streamable

    def initialize(stream = nil, &setup_block)
      if block_given? && stream.is_a?(Reactr::Streamable)
        raise "provided both a Reactr::Streamable and a setup block (which would create a lazy stream using a Reactr::Streamer), please use one or the other"
      end

      if block_given?
        @stream = Streamer.new &setup_block
      elsif stream.is_a? Reactr::Streamable
        @stream = stream
      end
    end

    def subscribe(handlers_or_streamer, override_handlers = {})
      raise "passed nil to subscribe" if handlers_or_streamer.nil?

      unless handlers_or_streamer.is_a?(Streamer) || handlers_or_streamer.is_a?(Hash)
        raise "first argument to subscribe must be a hash of :each, :success, and :failure handlers, or a broadcastable object"
      end

      each, success, failure = if handlers_or_streamer.is_a? Streamer
                                 streamer = handlers_or_streamer
                                 [
                                   override_handlers[:each]._? { lambda { |v| streamer << v } },
                                   override_handlers[:success]._? { lambda { streamer.done } },
                                   override_handlers[:failure]._? { lambda { |e| streamer.error e } }
                                 ]
                               else
                                 handlers = handlers_or_streamer
                                 [
                                   handlers[:each],
                                   handlers[:success],
                                   handlers[:failure]
                                 ]
                               end

      eaches << each if each
      successes << success if success
      failures << failure if failure

      start

      Reactr::Subscription.new self, each, success, failure
    end
    
    def start
      if @stream
        @stream.subscribe(
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
