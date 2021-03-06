module NaiveBayes
  module Backend
    class Memory
      attr_accessor :categories, :tokens_count, :categories_count

      def initialize(categories)
        @categories = categories

        clear!
      end

      def clear!
        @tokens_count = {}
        @categories_count = {}

        @categories.each do |category|
          @tokens_count[category] = Hash.new(0)
          @categories_count[category] = 0
        end
      end

      def train(category, *tokens)
        tokens.uniq.each do |token|
          @tokens_count[category][token] += 1
        end

        @categories_count[category] += 1
      end

      def untrain(category, *tokens)
        tokens.uniq.each do |token|
          @tokens_count[category][token] -= 1
        end

        @categories_count[category] -= 1
      end
    end
  end
end
