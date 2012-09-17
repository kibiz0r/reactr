module Reactr
  class Subscription
    attr_reader :each, :success, :failure

    def initialize(stream, each, success, failure)
      @stream = stream
      @each = each
      @success = success
      @failure = failure
    end

    def cancel
      @stream.cancel_subscription self
    end

    def cancel_after(&block)
      yield
      cancel
    end
  end
end
