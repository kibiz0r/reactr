module Reactr
  module Streamable
    def each(&block)
      subscribe each: block
    end

    def success(&block)
      subscribe success: block
    end

    def failure(&block)
      subscribe failure: block
    end

    def map(&block)
      Stream.new do |streamer|
        self.subscribe streamer,
          each: lambda { |value|
            streamer << block[value]
          }
      end
    end

    def map!(&block)
      map(&block).start
    end

    def flat_map(&block)
      Stream.new do |streamer|
        self.subscribe(
          each: lambda { |stream_itself|
            stream_itself.subscribe streamer
          }
        )
      end
    end

    def inject(initial = nil, sym = nil, &block)
      Stream.new do |streamer|
        memo_provided = !initial.nil?
        memo = initial

        self.subscribe each: lambda { |value|
            memo = if memo_provided
                     block[memo, value]
                   else
                     memo_provided = true
                     value
                   end
          },
          success: lambda {
            streamer << memo
            streamer.done
          },
          error: lambda { |e|
            streamer.error e
          }
      end
    end

    def concat(stream)
      Stream.new do |streamer|
        self.subscribe streamer,
          success: lambda {
            stream.subscribe streamer
          }
      end
    end

    def where(&filter)
      Stream.new do |streamer|
        self.subscribe streamer,
          each: lambda { |value|
            streamer << value if filter[value]
          }
      end
    end

    def reject(&filter)
      Stream.new do |streamer|
        self.subscribe streamer,
          each: lambda { |value|
            streamer << value unless filter[value]
          }
      end
    end

    def self.return(value)
      Stream.new do |streamer|
        streamer << value
        streamer.done
      end
    end
  end
end
