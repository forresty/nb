module NaiveBayes
  module Backend
    class Memory
      attr_accessor :categories, :tokens_count, :categories_count

      def initialize(categories)
        @categories = categories
        @tokens_count = {}
        @categories_count = {}

        categories.each do |category|
          @tokens_count[category] = Hash.new(0)
          @categories_count[category] = 0
        end
      end
    end
  end
end
