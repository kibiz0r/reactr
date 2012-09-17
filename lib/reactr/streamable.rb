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
      Streamer.new do |streamer|
        self.subscribe streamer,
          each: lambda do |value|
            streamer << block[value]
          end
      end
    end

    def map!(&block)
      map(&block).start
    end

    def inject(initial = nil, sym = nil, &block)
      Streamer.new do |streamer|
        memo_provided = !initial.nil?
        memo = initial

        self.subscribe streamer,
          each: lambda do |value|
            memo = if memo_provided
                     block[memo, value]
                   else
                     memo_provided = true
                     value
                   end
          end,
          success: lambda do
            streamer << memo
            streamer.done
          end
      end
    end

    def concat(stream)
      Streamer.new do |streamer|
        self.subscribe streamer,
          each: lambda do |value|
            streamer << value
          end,
          success: lambda do
            stream.subscribe streamer,
              each: lambda do |value|
                streamer << value
              end
          end
      end
    end

    def where(&filter)
      Streamer.new do |streamer|
        self.subscribe streamer,
          each: lambda do |value|
            streamer << value if filter[value]
          end
      end
    end

    def self.return(value)
      Streamer.new do |streamer|
        streamer << value
        streamer.done
      end
    end
  end
end
