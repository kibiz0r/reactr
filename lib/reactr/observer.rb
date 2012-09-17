module Reactr
  class Observer
    def initialize(on_next, on_completed = nil, on_error = nil)
      @on_next = on_next
      @on_completed = on_completed
      @on_error = on_error
    end

    def on_next(value)
      @on_next.call value
    end

    def on_completed
      @on_completed.call if @on_completed.is_a? Proc
    end

    def on_error(error)
      @on_error.call error if @on_error.is_a? Proc
    end
  end
end
