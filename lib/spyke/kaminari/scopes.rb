module Spyke::Kaminari
  module Scopes
    extend ActiveSupport::Concern

    included do
      %i{page per_page offset}.each do |symbol|
        scope symbol, ->(value) { where(symbol => value) }
      end
    end

    module ClassMethods
      delegate :metadata, to: :all

      Spyke::Kaminari::HEADERS.keys.each do |symbol|
        define_method(symbol) do
          metadata[Spyke::Kaminari::METADATA_KEY][symbol]
        end
      end

      def first_page?
        current_page == 1
      end

      def last_page?
        current_page == total_pages
      end

      def out_of_range?
        current_page > total_pages
      end

      def each_page
        return to_enum(:each_page) unless block_given?

        relation = all.clone
        yield relation
        return if relation.last_page? || relation.out_of_range?

        (relation.next_page..relation.total_pages).each do |number|
          yield clone.page(number)
        end
      end
    end
  end
end
