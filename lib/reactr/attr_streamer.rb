module Reactr
  module AttrStreamer
    def attr_streamer(*attrs)
      attrs.each do |attr|
        streamer = Reactr::Streamer.new

        define_method :"#{attr}=" do |value|
          streamer << value
        end

        define_method attr do
          streamer
        end
      end
    end
  end
end
