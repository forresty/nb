require "spec_helper"

module NaiveBayes
  module Backend
    describe Redis do
      it { should respond_to :categories= }
    end
  end
end
