require "spec_helper"

module NaiveBayes
  describe Classifier do
    let(:classifier) { Classifier.new(:love, :hate) }
    subject { classifier }

    it { should respond_to :train }
    it { should respond_to :untrain }
    it { should respond_to :save }
    it { should respond_to :classify }
    it { should respond_to :classifications }
    it { should respond_to :probability_of_a_token_given_a_category }
    it { should respond_to :probability_of_tokens_given_a_category }
    it { should respond_to :probability_of_a_category }
    it { should respond_to :probability_of_a_token_in_category }
    # it { should respond_to :total_number_of_tokens }
    it { should respond_to :total_number_of_items }
    it { should respond_to :top_tokens_of_category }
    it { should respond_to :default_category= }

    [:memory, :redis].each do |backend|
      describe "with backend #{backend}" do

        let(:classifier) { Classifier.new(:love, :hate, backend: backend) }

        subject { classifier }

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

        describe '#probability_of_a_token_in_category' do
          it 'calculates correctly' do
            subject.train :love, 'I', 'love', 'you'
            subject.train :hate, 'I', 'hate', 'you'

            subject.probability_of_a_token_in_category('love', :love).should == 2.0/3  # 1 / ( 1 + 0.5 )
            subject.probability_of_a_token_in_category('hate', :love).should == 1.0/3  # 0.5 / ( 1 + 0.5 )
            subject.probability_of_a_token_in_category('I', :love).should == 0.5

            subject.train :love, 'hate', 'is', 'love'
            subject.train :love, 'hate', 'is', 'love'
            subject.train :love, 'hate', 'is', 'love'

            subject.probability_of_a_token_in_category('love', :love).should == 5.0/6  # 1 / ( 1 + 0.2 )
            subject.probability_of_a_token_in_category('hate', :love).should == 3.0/7  # 0.75 / ( 0.75 + 1 )
          end
        end

        describe '#total_number_of_items' do
          it 'calculates correctly' do
            subject.train :love, 'I', 'love', 'you'
            subject.train :hate, 'I', 'hate', 'you'

            subject.total_number_of_items.should == 2

            subject.train :love, 'I', 'love', 'you', 'more'

            subject.total_number_of_items.should == 3
          end
        end

        describe '#probability_of_a_category' do
          it 'calculates correctly' do
            subject.train :love, 'I', 'love', 'you'
            subject.train :hate, 'I', 'hate', 'you'

            subject.probability_of_a_category(:love).should == 0.5
          end
        end

        describe '#probability_of_token_given_a_category' do
          it 'calculates correctly' do
            subject.train :love, 'I', 'love', 'you'
            subject.train :hate, 'I', 'hate', 'you'

            subject.probability_of_a_token_given_a_category('love', :love).should == 1
            subject.probability_of_a_token_given_a_category('you', :hate).should == 1

            subject.train :love, 'I', 'love', 'you', 'more'

            subject.probability_of_a_token_given_a_category('more', :love).should == 0.5
            # bayes.probability_of_token_given_a_category('more', :hate).should == 0
          end
        end

        describe '#classifications' do
          it 'calculates correctly' do
            subject.train :love, 'I', 'love', 'you'
            subject.train :hate, 'I', 'hate', 'you'

            subject.classifications(*%w{ I love you }).should == [[:love, 0.5], [:hate, 0.25]]
            subject.classify(*%w{ I love you }).should == [:love, 0.5]
            subject.classify(*%w{ love }).should == [:love, 0.5]

            subject.train :love, 'I', 'love', 'you'
            subject.train :love, 'I', 'love', 'you'
            subject.train :love, 'I', 'love', 'you'

            subject.classify(*%w{ I love you }).should == [:love, 0.8]
            subject.classify(*%w{ love }).should == [:love, 0.8]
            subject.classify(*%w{ only love }).first.should == :love #[:love, 0.16], (0.2 * 1) * 0.8
          end
        end

        describe '#top_tokens_of_category' do
          it 'finds to tokens' do
            subject.train :love, 'I', 'love', 'you'
            subject.train :hate, 'I', 'hate', 'you'

            subject.top_tokens_of_category(:love).count.should == 3
          end
        end
      end
    end

    describe 'class methods' do
      subject { Classifier }

      it { should respond_to :load_yaml }
    end
  end
end
