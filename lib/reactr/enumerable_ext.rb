module Enumerable
  def to_stream
    Reactr::Stream.new do |proxy|
      self.each do |value|
        proxy << value
      end
      proxy.done
    end
  end
end
