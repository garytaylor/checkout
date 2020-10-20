# frozen_string_literal: true

require_relative './discount_applied'
module Promotions
  # An product quantity promotion that can apply a discount based on the products in an order
  class ProductQuantityPromotion
    FIXED_AMOUNT_TYPE = 'FixedAmount'
    attr_accessor :product_code, :minimum_quantity, :discount_amount, :discount_type

    def initialize(discount_applied_class: DiscountApplied)
      @discount_applied_class = discount_applied_class
    end

    def apply(products:, discounts_applied:, **)
      product_count = products.count { |product| product.code == product_code }
      return if product_count < minimum_quantity

      apply_discount(product_count, discounts_applied)
    end

    def product_level?
      true
    end

    def order_level?
      false
    end

    private

    attr_reader :discount_applied_class

    def apply_discount(product_count, discounts_applied)
      discounts_applied << discount_applied_class.new(amount: discount_to_apply(product_count), rule: self)
    end

    def discount_to_apply(product_count)
      case discount_type
      when FIXED_AMOUNT_TYPE then discount_amount * product_count
      else raise "Unknown discount type #{discount_type}"
      end
    end
  end
end
