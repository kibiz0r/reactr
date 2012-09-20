module Reactr
  module AttrStreamer
    def attr_streamer(*attrs)
      attrs.each do |attr|
        streamer = Reactr::Streamer.new
        stream = Reactr::Stream.new streamer

        define_method :"#{attr}=" do |value|
          streamer << value
        end

        define_method attr do
          stream
        end
      end
    end
  end
end
