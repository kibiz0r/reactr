require 'spec_helper'

describe Reactr::Stream do
  describe "#process_next" do
    it "yields a value" do
      expect do |b|
        subject.each &b
        subject.send :process_next, 'a value'
      end.to yield_with_args('a value')
    end

    it "yields two values" do
      expect do |b|
        subject.each &b
        subject.send :process_next, 'one value'
        subject.send :process_next, 'two value'
      end.to yield_successive_args('one value', 'two value')
    end
  end

  describe "#process_done" do
    it "notifies subscribers" do
      expect do |b|
        subject.success &b
        subject.send :process_done
      end.to yield_with_no_args
    end

    it "ends the stream" do
      subject.send :process_done
      subject.should be_ended
    end
  end

  describe "#process_error" do
    it "notifies subscribers" do
      expect do |b|
        subject.failure &b
        subject.send :process_error, 'an error'
      end.to yield_with_args('an error')
    end

    it "ends the stream" do
      subject.send :process_error, nil
      subject.should be_ended
    end
  end
end
