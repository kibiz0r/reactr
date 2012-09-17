module Reactr
  class Stream
    include Reactr::Streamable

    def subscribe(handlers)
      each = handlers[:each]
      success = handlers[:success]
      failure = handlers[:failure]

      eaches << each if each
      successes << success if success
      failures << failure if failure

      Reactr::Subscription.new self, each, success, failure
    end
    
    def start
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
