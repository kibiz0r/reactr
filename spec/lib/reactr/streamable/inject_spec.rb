require 'spec_helper'

class Foo
  attr_streamer :bar
end

describe Reactr::Streamable do
  describe "#inject" do
    subject do
      Reactr::Stream.new do |streamer|
        1.upto 9 do |n|
          streamer << n
        end
        streamer.done
      end
    end

    it "works" do
      subject.inject(&:+).to_a.should == [45]
    end
  end

  describe "something" do
    subject do
      Foo.new
    end

    it "does stuff" do
      bar_squared = subject.bar.map do |n|
        n * n
      end
      bar_squared.each do |n|
        puts n
      end.cancel_after do
        subject.bar = 5
        subject.bar = 10
        subject.bar = 4
        subject.bar = 2
      end
    end
  end
end
