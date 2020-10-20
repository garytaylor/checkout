# frozen_string_literal: true

require_relative './discount_applied'
module Promotions
  # An order total promotion that can apply a discount based on order total
  class OrderTotalPromotion
    PERCENT_TYPE = 'Percent'
    attr_accessor :minimum_value, :discount_amount, :discount_type

    def initialize(discount_applied_class: DiscountApplied)
      @discount_applied_class = discount_applied_class
    end

    def apply(discounts_applied:, total:, **)
      return if total <= minimum_value

      apply_discount(total, discounts_applied)
    end

    def product_level?
      false
    end

    def order_level?
      true
    end

    private

    attr_reader :discount_applied_class

    def apply_discount(order_total, discounts_applied)
      discounts_applied << discount_applied_class.new(amount: discount_to_apply(order_total), rule: self)
    end

    def discount_to_apply(order_total)
      case discount_type
      when PERCENT_TYPE then order_total * (discount_amount / 100)
      else raise "Unknown discount type #{discount_type}"
      end
    end
  end
end
