# frozen_string_literal: true

module Promotions
  # A service to assist in calculating and applying promotions
  class CalculatorService


    # @param [Array<Product>] products The list of products to purchase
    # @param [Array<OrderTotalPromotion,ProductQuantityPromotion>] rules The promotion rules to apply
    # @param [Array<DiscountApplied>] discounts_applied The discounts that have been applied as a result of the rules
    def self.call(products:, rules:, discounts_applied:)
      rules_to_apply = rules - discounts_applied.map(&:rule)
      rules_to_apply.each do |rule|
        rule.apply(products: products, discounts_applied: discounts_applied)
      end
    end
  end
end
