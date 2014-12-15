require "spec_helper"

module NaiveBayes
  module Backend
    describe Memory do
      it { should respond_to :categories= }
    end
  end
end
