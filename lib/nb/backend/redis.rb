require "redis"

module NaiveBayes
  module Backend
    class Redis
      attr_accessor :categories, :tokens_count, :categories_count

      def initialize(categories, options={})
        @categories = categories

        @redis = ::Redis.new(options)
      end

      def train(category, *tokens)
        raise 'not implemented yet'
      end

      def untrain(category, *tokens)
        raise 'not implemented yet'
      end
    end
  end
end
