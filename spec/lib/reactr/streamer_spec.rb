require 'spec_helper'

describe Reactr::Streamer do
  describe "laziness" do
    subject do
      described_class.new do |streamer|
        streamer << 'lazy'
        streamer << 'values'
      end
    end

    it "allows a block to provide its value stream at initialization" do
      expect do |b|
        subject.each &b
      end.to yield_successive_args('lazy', 'values')
    end
  end

  describe "valid streams" do
    specify "5" do
      subject << 5
    end

    specify "'a' 'b'" do
      subject << 'a'
      subject << 'b'
    end

    specify "[done]" do
      subject.done
    end
    
    specify "18 [done]" do
      subject << 18
      subject.done
    end

    specify "'foo' [error]" do
      subject << 'foo'
      subject.error
    end
  end

  describe "invalid streams" do
    specify "[done] [done]" do
      lambda do
        subject.done
        subject.done
      end.should raise_error
    end

    specify "[error] [error]" do
      lambda do
        subject.error
        subject.error
      end.should raise_error
    end

    specify "[done] 5" do
      lambda do
        subject.done
        subject << 5
      end.should raise_error
    end

    specify "[error] 'a' 'b'" do
      lambda do
        subject.error
        subject << 'a'
        subject << 'b'
      end.should raise_error
    end

    specify "3 [done] 5" do
      lambda do
        subject << 3
        subject.done
        subject << 5
      end.should raise_error
    end

    specify "'z' [error] 'a' 'b'" do
      lambda do
        subject << 'z'
        subject.error
        subject << 'a'
        subject << 'b'
      end.should raise_error
    end

    specify "[done] [error]" do
      lambda do
        subject.done
        subject.error
      end.should raise_error
    end
    
    specify "[error] [done]" do
      lambda do
        subject.error
        subject.done
      end.should raise_error
    end

    specify "'foo' [done] [error]" do
      lambda do
        subject << 'foo'
        subject.done
        subject.error
      end.should raise_error
    end
    
    specify "'foo' [error] [done]" do
      lambda do
        subject << 'foo'
        subject.error
        subject.done
      end.should raise_error
    end
  end
end
