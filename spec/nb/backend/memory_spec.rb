require "spec_helper"

module NaiveBayes
  module Backend
    describe Memory do
      subject { Memory.new [:ham, :spam] }

      it { should respond_to :categories= }
      it { should respond_to :train }
      it { should respond_to :untrain }
    end
  end
end
