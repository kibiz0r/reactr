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
          each: lambda { |value|
            block[value].subscribe streamer
          }
        )
      end
    end

    def inject(initial = nil, sym = nil, &block)
      Stream.new do |streamer|
        memo_provided = !initial.nil?
        memo = initial

        self.subscribe streamer,
          each: lambda { |value|
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

    def invoke(&block)
      Stream.new do |streamer|
        self.subscribe streamer,
          each: lambda { |value|
            block[value]
            streamer << value
          }
      end
    end

    def skip_until(stream)
      Stream.new do |streamer|
        self.subscribe streamer,
          each: lambda { |value|
            streamer << value if stream.ended?
          }
      end
    end

    def wait_until(stream)
      Stream.new do |streamer|
        stream.subscribe success: lambda {
          self.subscribe streamer
        }
      end
    end

    def upon(stream)
      Reactr::Stream.new do |proxy|
        stream.success do
          self.subscribe proxy
        end
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

    def self.return(value = nil)
      Stream.new do |streamer|
        streamer << value
        streamer.done
      end
    end
  end
end
