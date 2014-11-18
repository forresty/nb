require "spec_helper"

describe NaiveBayes do
  it { should respond_to :train }
  it { should respond_to :save }

  describe 'class methods' do
    subject { NaiveBayes }

    it { should respond_to :load_yaml }
  end
end
