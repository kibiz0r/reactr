require 'spec_helper'

describe Reactr::Streamable do
  describe "#concat" do
    let :one_stream do
      Reactr::Streamer.new
    end

    let :two_stream do
      Reactr::Streamer.new
    end

    subject do
      one_stream.concat two_stream
    end

    context "when the first stream is done" do
      it "subscribes to the second stream" do
        expect do |b|
          subject.on_next &b
          one_stream << 'one'
          one_stream.done
          two_stream << 'two'
        end.to yield_successive_args('one', 'two')
      end
    end

    context "when the second stream is done" do
      it "is done" do
        expect do |b|
          subject.on_done &b
          one_stream << 'lalala'
          one_stream.done
          two_stream << 'whatever'
          two_stream.done
        end.to yield_with_no_args
      end
    end

    context "when the first stream errors" do
      it "stops at the error" do
        expect do |b|
          subject.on_next &b
          one_stream << 'inb4'
          one_stream.error
          two_stream << 'never'
        end.to yield_with_args('inb4')
      end
    end

    context "when the second stream errors" do
      it "propagates the error" do
        expect do |b|
          subject.on_error &b
          one_stream << 'lalala'
          one_stream.done
          two_stream << 'whatever'
          two_stream.error 'an error'
        end.to yield_with_args('an error')
      end
    end
  end
end
