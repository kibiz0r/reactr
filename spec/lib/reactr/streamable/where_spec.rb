require 'spec_helper'

describe Reactr::Streamable do
  describe "#where" do
    subject do
      Reactr::Streamer.new do |streamer|
        streamer << 3
        streamer << 23
        streamer << 9
        streamer << 72
        streamer << 5
        streamer.done
      end
    end

    it "only includes values that pass the filter" do
      expect do |b|
        subject.where { |n| n < 10 }.each &b
      end.to yield_successive_args(3, 9, 5)
    end

    it "can become an array" do
      subject.where { |n| n < 10 }.to_a.should == [3, 9, 5]
    end

    context "when the source stream is done" do
      it "is done" do
        expect do |b|
          subject.where { |n| n < 10 }.success &b
        end.to yield_with_no_args
      end
    end
  end
end
