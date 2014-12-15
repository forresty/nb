require "spec_helper"

module NaiveBayes
  module Backend
    describe Redis do
      subject { Redis.new [:ham, :spam] }

      it { should respond_to :categories= }
    end
  end
end
