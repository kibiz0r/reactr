module Reactr
  class StreamEndedError < RuntimeError
    def initialize
      super "Attempted to end a stream that was already ended!"
    end
  end
end
