module Reactr
  module AttrStream
    def attr_stream(*attrs)
      attrs.each do |attr|
        streamer = Reactr::Streamer.new
        stream = Reactr::Stream.new streamer

        define_method :"#{attr}=" do |value|
          streamer << value
        end

        protected :"#{attr}="

        define_method attr do
          stream
        end
      end
    end
  end
end
