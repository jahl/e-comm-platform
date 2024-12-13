# frozen_string_literal: true

module Products
  class ImportFromCsv < ApplicationService
    attr_reader :csv, :category_names

    def initialize(csv)
      @csv = csv
      @category_names = Set.new
    end

    def run
      create_categories_from_rows
      create_products_from_rows
    end

    private

    def create_categories_from_rows
      @csv.each do |row|
        category_name = row['CATEGORY']
        next if category_name.blank?

        category_names.add(category_name.upcase)
      end

      Category.collection.bulk_write(category_operations)
    end

    def category_operations
      category_names.map do |category_name|
        {
          update_one: {
            filter: { name: category_name },
            update: { '$setOnInsert': { name: category_name } },
            upsert: true
          }
        }
      end
    end

    def create_products_from_rows
      Product.collection.bulk_write(product_operations)
    end

    def product_operations
      @csv.map do |row|
        build_product_operation(row)
      end.compact
    end

    # rubocop:disable Metrics/MethodLength
    def build_product_operation(row)
      category_name = row['CATEGORY']
      return unless category_name

      category_id = categories[category_name.upcase]
      return unless category_id

      product_name = row['NAME']
      return if product_name.blank?

      default_price = parse_price(row['DEFAULT_PRICE'])
      return unless default_price

      quantity = parse_quantity(row['QTY'])
      return unless quantity

      {
        update_one: {
          filter: {
            name: product_name,
            category_id: category_id
          },
          update: {
            '$set': {
              name: product_name,
              default_price: default_price,
              category_id: category_id
            },
            '$inc': {
              quantity: quantity
            }
          },
          upsert: true
        }
      }
    end
    # rubocop:enable Metrics/MethodLength

    def parse_price(price_value)
      price = price_value&.to_f
      price.present? && price.positive? ? price : nil
    end

    def parse_quantity(quantity_value)
      quantity = quantity_value&.to_i
      quantity.present? && quantity >= 0 ? quantity : nil
    end

    def categories
      @categories ||= Category.where(:name.in => category_names.to_a).each_with_object({}) do |category, hash|
        hash[category.name] = category.id
      end
    end
  end
end
