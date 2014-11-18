require "spec_helper"

describe NaiveBayes do
  it { should respond_to :train }
  it { should respond_to :save }
  it { should respond_to :classify }
  it { should respond_to :classifications }
  it { should respond_to :probability_of_a_token_given_a_category }
  it { should respond_to :probability_of_tokens_given_a_category }
  it { should respond_to :probability_of_a_category }
  # it { should respond_to :total_number_of_tokens }
  it { should respond_to :total_number_of_items }

  let(:bayes) { NaiveBayes.new(:love, :hate) }
  subject { bayes }

  # describe '#total_number_of_tokens' do
  #   it 'calculates correctly' do
  #     bayes.train :love, 'I', 'love', 'you'
  #     bayes.train :hate, 'I', 'hate', 'you'
  #
  #     bayes.total_number_of_tokens.should == 6
  #
  #     bayes.train :love, 'I', 'love', 'you', 'more'
  #
  #     bayes.total_number_of_tokens.should == 10
  #   end
  # end

  describe '#total_number_of_items' do
    it 'calculates correctly' do
      bayes.train :love, 'I', 'love', 'you'
      bayes.train :hate, 'I', 'hate', 'you'

      bayes.total_number_of_items.should == 2

      bayes.train :love, 'I', 'love', 'you', 'more'

      bayes.total_number_of_items.should == 3
    end
  end

  describe '#probability_of_a_category' do
    it 'calculates correctly' do
      bayes.train :love, 'I', 'love', 'you'
      bayes.train :hate, 'I', 'hate', 'you'

      bayes.probability_of_a_category(:love).should == 0.5
    end
  end

  describe '#probability_of_token_given_a_category' do
    it 'calculates correctly' do
      bayes.train :love, 'I', 'love', 'you'
      bayes.train :hate, 'I', 'hate', 'you'

      bayes.probability_of_a_token_given_a_category('love', :love).should == 1
      bayes.probability_of_a_token_given_a_category('you', :hate).should == 1

      bayes.train :love, 'I', 'love', 'you', 'more'

      bayes.probability_of_a_token_given_a_category('more', :love).should == 0.5
      # bayes.probability_of_token_given_a_category('more', :hate).should == 0
    end
  end

  describe '#classifications' do
    it 'calculates correctly' do
      bayes.train :love, 'I', 'love', 'you'
      bayes.train :hate, 'I', 'hate', 'you'

      bayes.classifications(*%w{ I love you }).should == [[:love, 0.5], [:hate, 0.25]]
      bayes.classify(*%w{ I love you }).should == [:love, 0.5]
      bayes.classify(*%w{ love }).should == [:love, 0.5]

      bayes.train :love, 'I', 'love', 'you'
      bayes.train :love, 'I', 'love', 'you'
      bayes.train :love, 'I', 'love', 'you'

      bayes.classify(*%w{ I love you }).should == [:love, 0.8]
      bayes.classify(*%w{ love }).should == [:love, 0.8]
      bayes.classify(*%w{ only love }).first.should == :love #[:love, 0.16], (0.2 * 1) * 0.8
    end
  end

  describe 'class methods' do
    subject { NaiveBayes }

    it { should respond_to :load_yaml }
  end
end
