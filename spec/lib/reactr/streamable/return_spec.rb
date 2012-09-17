require 'spec_helper'

describe Reactr::Streamable do
  describe ".return" do
    subject do
      Reactr::Streamable.return 5
    end

    it "yields 5" do
      expect do |b|
        subject.on_next &b
      end.to yield_with_args(5)
    end

    it "ends" do
      expect do |b|
        subject.on_done &b
      end.to yield_with_no_args
    end
  end
end
