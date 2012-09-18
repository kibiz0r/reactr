require 'spec_helper'

describe Reactr::Streamable do
  describe "#concat" do
    context "when the first stream is done" do
      subject do
        Reactr::Stream.new { |streamer|
          streamer << 'one'
          streamer.done
        }.concat Reactr::Stream.new { |streamer|
          streamer << 'two'
        }
      end

      it "subscribes to the second stream" do
        expect do |b|
          subject.each &b
        end.to yield_successive_args('one', 'two')
      end
    end

    context "when the second stream is done" do
      subject do
        Reactr::Stream.new { |streamer|
          streamer << 'lalala'
          streamer.done
        }.concat Reactr::Stream.new { |streamer|
          streamer << 'whatever'
          streamer.done
        }
      end

      it "is done" do
        expect do |b|
          subject.success &b
        end.to yield_with_no_args
      end
    end

    context "when the first stream errors" do
      subject do
        Reactr::Stream.new { |streamer|
          streamer << 'inb4'
          streamer.error
        }.concat Reactr::Stream.new { |streamer|
          streamer << 'never'
          streamer.done
        }
      end

      it "stops at the error" do
        expect do |b|
          subject.each &b
        end.to yield_with_args('inb4')
      end
    end

    context "when the second stream errors" do
      subject do
        Reactr::Stream.new { |streamer|
          streamer << 'lalala'
          streamer.done
        }.concat Reactr::Stream.new { |streamer|
          streamer << 'whatever'
          streamer.error 'an error'
        }
      end

      it "propagates the error" do
        expect do |b|
          subject.failure &b
        end.to yield_with_args('an error')
      end
    end
  end
end
